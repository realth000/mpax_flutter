import 'dart:math';

import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../services/database_service.dart';
import 'music_model.dart';

part 'playlist_model.g.dart';

/// Const name for the special [Playlist] contains all music.
/// There should be only one playlist using this name and always be.
const libraryPlaylistName = 'all_music_library_name';

/// Model of playlist.
///
/// Maintains a list of audio files, and information/property about playlist.
@Collection()
class Playlist {
  /// Constructor.
  Playlist();

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Playlist name, human readable name.
  ///
  /// Allow duplicate, works like foobar2000.
  ///
  /// There's a special playlist which contains all [Music] and acts like music
  /// library. That playlist's name should be a const value and all other
  /// playlists should not have a same name.
  /// When searching data, filter that playlist according to whether search in
  /// music library.
  /// Put that playlist in the same Playlist Isar schema because it's actually
  /// another playlist.
  /// Now name is set to [libraryPlaylistName].
  @Index()
  String name = '';

  /// All music.
  ///
  /// All [Music] link saved in must NOT be null.
  /// TODO: Check whether deleting a [Music] will leave an empty [IsarLink].
  /// If so, we should check every time access them or keep observing.
  final musicList = IsarLinks<Music>();

  /// Load all music to a playlist.
  static Future<Playlist> loadAllMusicSyncToPlaylist() async {
    final playlist = Playlist();
    final allMusic =
        await Get.find<DatabaseService>().storage.musics.where().findAll();
    playlist
      ..name = 'all_media'
      ..clearMusicList()
      ..addMusicList(allMusic);
    return playlist;
  }

  /// Whether is an empty playlist.
  bool get isEmpty => musicIdSortList.isEmpty;

  /// Store [Music] sort in [musicList] by Music's [Id].
  ///
  /// Every time added or deleted [Music] in [musicList], update sort.
  /// Every change on sort not need to update [musicList].
  final musicIdSortList = <Id>[];

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  // TODO: Maybe should implement this with database.
  bool contains(Music music) => musicIdSortList.contains(music.id);

  /// Find music in [musicList] by [Music.id].
  Music? _findMusicById(Id id) {
    for (final music in musicList) {
      if (music.id == id) {
        return music;
      }
    }
    return null;
  }

  /// Tell if the specified path file already exists in playlist.
  // TODO: Maybe should implement this with database.
  Music? find(String contentPath) {
    for (final content in musicList) {
      if (content.filePath == contentPath) {
        return content;
      }
    }
    return null;
  }

  /// Add music to current playlist.
  /// No duplicate file path.
  Future<void> addMusic(Music music) async {
    if (contains(music)) {
      return;
    }
    musicList.add(music);
    musicIdSortList.add(music.id);
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await musicList.save();
    });
  }

  /// Add a list of audio model to playlist, not duplicate with same path file.
  Future<void> addMusicList(List<Music> musicList) async {
    for (final music in musicList) {
      print('AAAA check music id=${music.id}');
      // TODO: Maybe [IsarLink] is similar to [Set], which means we do not need to prevent repeat.
      if (contains(music)) {
        continue;
      }
      print('AAAA add music id =${music.id}!!');
      this.musicList.add(music);
      musicIdSortList.add(music.id);
    }
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await this.musicList.save();
      await storage.playlists.put(this);
    });
  }

  /// Remove [music] from current [Playlist].
  Future<void> removeMusic(Music music) async {
    musicIdSortList.removeWhere((id) => id == music.id);
    musicList.removeWhere((m) => m.filePath == music.filePath);
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await musicList.save();
    });
  }

  /// Remove all music under [folderPath].
  ///
  /// This does nothing to the folder monitoring list.
  /// Only as a convenience method to delete all music under a folder.
  Future<void> removeMusicByMusicFolder(String folderPath) async {
    final idList = <int>[];
    musicList.removeWhere((music) {
      if (music.filePath.startsWith(folderPath)) {
        idList.add(music.id);
        return true;
      }
      return false;
    });
    for (final id in idList) {
      final _ = musicIdSortList.remove(id);
    }
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await musicList.save();
      await storage.playlists.put(this);
    });
  }

  /// Clear audio file list.
  void clearMusicList() {
    musicList.clear();
    musicIdSortList.clear();
  }

  /// Find previous audio content of the given playContent.
  ///
  /// If it's the first one, the last one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findPreviousMusic(Music music) {
    if (musicIdSortList.isEmpty) {
      return null;
    }
    if (!musicIdSortList.contains(music.id)) {
      return null;
    }
    if (musicIdSortList.first == music.id) {
      return _findMusicById(musicIdSortList.last);
    }
    final pos = musicIdSortList.firstWhereOrNull((id) => id == music.id);
    if (pos == null) {
      return null;
    }
    return _findMusicById(musicIdSortList[pos - 1]);
  }

  /// Find next audio content of the given playContent.
  ///
  /// If it's the last one, the first one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findNextContent(Music music) {
    if (musicList.isEmpty) {
      return null;
    }
    if (!musicIdSortList.contains(music.id)) {
      return null;
    }
    if (musicIdSortList.last == music.id) {
      return _findMusicById(musicIdSortList.first);
    }
    final pos = musicIdSortList.firstWhereOrNull((id) => id == music.id);
    if (pos == null) {
      return null;
    }
    return _findMusicById(musicIdSortList[pos + 1]);
  }

  /// Return a random audio content in playlist.
  Music? randomPlayContent() {
    if (musicList.isEmpty) {
      return null;
    }
    return _findMusicById(
      musicIdSortList[Random().nextInt(musicIdSortList.length)],
    );
  }

  /// Remove same [Music] with same [filePathList].
// Future<void> removeByPathList(List<String> filePathList) async {
//   musicList.removeWhere(
//     (content) => filePathList.contains(content.value!.filePath),
//   );
// }
}
