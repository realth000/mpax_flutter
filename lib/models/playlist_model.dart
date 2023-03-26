import 'dart:math';

import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../services/database_service.dart';
import 'music_model.dart';

part 'playlist_model.g.dart';

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
  @Index()
  String name = '';

  /// All music.
  ///
  /// All [Music] link saved in must NOT be null.
  /// TODO: Check whether deleting a [Music] will leave an empty [IsarLink].
  /// If so, we should check every time access them or keep observing.
  final _musicList = IsarLinks<Music>();

  /// Get current music List.
  @ignore
  List<Music> get musicList {
    final ret = <Music>[];
    for (final id in _musicIdSortList) {
      final m = _findMusicById(id);
      if (m == null) {
        continue;
      }
      ret.add(_findMusicById(id)!);
    }
    return ret;
  }

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
  bool get isEmpty => _musicIdSortList.isEmpty;

  /// Store [Music] sort in [_musicList] by Music's [Id].
  ///
  /// Every time added or deleted [Music] in [_musicList], update sort.
  /// Every change on sort not need to update [_musicList].
  final _musicIdSortList = <Id>[];

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  // TODO: Maybe should implement this with database.
  bool contains(Music music) => _musicIdSortList.contains(music.id);

  /// Find music in [_musicList] by [Music.id].
  Music? _findMusicById(Id id) {
    for (final music in _musicList) {
      if (music.id == id) {
        return music;
      }
    }
    return null;
  }

  /// Tell if the specified path file already exists in playlist.
  // TODO: Maybe should implement this with database.
  Music? find(String contentPath) {
    for (final content in _musicList) {
      if (content.filePath == contentPath) {
        return content;
      }
    }
    return null;
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
      _musicList.add(music);
      _musicIdSortList.add(music.id);
    }
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async => _musicList.save());
    print(
        'AAAA 1111111111 len=${_musicList.length},${_musicIdSortList.length}');
  }

  /// Clear audio file list.
  void clearMusicList() {
    _musicList.clear();
    _musicIdSortList.clear();
  }

  /// Find previous audio content of the given playContent.
  ///
  /// If it's the first one, the last one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findPreviousMusic(Music music) {
    if (_musicIdSortList.isEmpty) {
      return null;
    }
    if (!_musicIdSortList.contains(music.id)) {
      return null;
    }
    if (_musicIdSortList.first == music.id) {
      return _findMusicById(_musicIdSortList.last);
    }
    final pos = _musicIdSortList.firstWhereOrNull((id) => id == music.id);
    if (pos == null) {
      return null;
    }
    return _findMusicById(_musicIdSortList[pos - 1]);
  }

  /// Find next audio content of the given playContent.
  ///
  /// If it's the last one, the first one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findNextContent(Music music) {
    if (_musicList.isEmpty) {
      return null;
    }
    if (!_musicIdSortList.contains(music.id)) {
      return null;
    }
    if (_musicIdSortList.last == music.id) {
      return _findMusicById(_musicIdSortList.first);
    }
    final pos = _musicIdSortList.firstWhereOrNull((id) => id == music.id);
    if (pos == null) {
      return null;
    }
    return _findMusicById(_musicIdSortList[pos + 1]);
  }

  /// Return a random audio content in playlist.
  Music? randomPlayContent() {
    if (_musicList.isEmpty) {
      return null;
    }
    return _findMusicById(
      _musicIdSortList[Random().nextInt(_musicIdSortList.length)],
    );
  }

  /// Remove same [Music] with same [filePathList].
// Future<void> removeByPathList(List<String> filePathList) async {
//   _musicList.removeWhere(
//     (content) => filePathList.contains(content.value!.filePath),
//   );
// }
}
