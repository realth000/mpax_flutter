import 'dart:math';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/services/database_service.dart';

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
  /// If so, we should check every time access them or keep observing.
  final musicList = <Id>[];

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
  bool get isEmpty => musicList.isEmpty;

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  // TODO: Maybe should implement this with database.
  bool contains(Music music) => musicList.contains(music.id);

  /// Tell if the specified path file already exists in playlist.
  // TODO: Maybe should implement this with database.
  // TODO: Check usage.
  Music? find(String contentPath) {
    for (final content in musicList) {
      final musicContent = Get.find<DatabaseService>()
          .storage
          .musics
          .where()
          .idEqualTo(content)
          .findFirstSync();
      if (musicContent == null) {
        continue;
      }
      if (musicContent.filePath == contentPath) {
        return musicContent;
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
    musicList.add(music.id);
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await storage.playlists.put(this);
    });
  }

  /// Add a list of audio model to playlist, not duplicate with same path file.
  Future<void> addMusicList(List<Music> musicList) async {
    for (final music in musicList) {
      if (contains(music)) {
        continue;
      }
      this.musicList.add(music.id);
      final storage = Get.find<DatabaseService>().storage;
      await storage.writeTxn(() async {
        await storage.playlists.put(this);
      });
    }
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await storage.playlists.put(this);
    });
  }

  /// Remove [music] from current [Playlist].
  Future<void> removeMusic(Music music) async {
    musicList.removeWhere((m) => m == music.id);
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn<void>(() async {
      await storage.playlists.put(this);
    });
  }

  /// Remove all music under [folderPath].
  ///
  /// This does nothing to the folder monitoring list.
  /// Only as a convenience method to delete all music under a folder.
  Future<void> removeMusicByMusicFolder(String folderPath) async {
    final idList = (await Get.find<DatabaseService>()
            .storage
            .musics
            .filter()
            .filePathStartsWith(folderPath)
            .findAll())
        .map((e) => e.id);
    for (final id in idList) {
      musicList.remove(id);
    }
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await storage.playlists.put(this);
    });
  }

  /// Clear audio file list.
  void clearMusicList() {
    musicList.clear();
  }

  /// Find previous audio content of the given playContent.
  ///
  /// If it's the first one, the last one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findPreviousMusic(Music music) {
    if (musicList.isEmpty) {
      return null;
    }
    // if (!musicIdSortList.contains(music.id)) {
    //   return null;
    // }
    if (musicList.first == music.id) {
      return Get.find<DatabaseService>()
          .storage
          .musics
          .where()
          .idEqualTo(musicList.last)
          .findFirstSync();
    }
    final pos = musicList.indexOf(music.id);
    if (pos == -1) {
      return null;
    }
    return Get.find<DatabaseService>()
        .storage
        .musics
        .where()
        .idEqualTo(musicList.elementAt(pos + 1))
        .findFirstSync();
  }

  /// Find next audio content of the given playContent.
  ///
  /// If it's the last one, the first one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findNextContent(Music music) {
    if (musicList.isEmpty) {
      return null;
    }
    if (musicList.last == music.id) {
      return Get.find<DatabaseService>()
          .storage
          .musics
          .where()
          .idEqualTo(musicList.first)
          .findFirstSync();
    }
    final pos = musicList.indexOf(music.id);
    if (pos == -1) {
      return null;
    }
    return Get.find<DatabaseService>()
        .storage
        .musics
        .where()
        .idEqualTo(musicList.elementAt(pos - 1))
        .findFirstSync();
  }

  /// Return a random audio content in playlist.
  Music? randomPlayContent() {
    if (musicList.isEmpty) {
      return null;
    }
    return Get.find<DatabaseService>()
        .storage
        .musics
        .where()
        .idEqualTo(musicList.elementAt(Random().nextInt(musicList.length)))
        .findFirstSync();
  }

  /// Remove same [Music] with same [filePathList].
// Future<void> removeByPathList(List<String> filePathList) async {
//   musicList.removeWhere(
//     (content) => filePathList.contains(content.value!.filePath),
//   );
// }
}
