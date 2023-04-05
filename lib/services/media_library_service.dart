import 'dart:io';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;
import 'package:path/path.dart' as path;

import '../mobile/services/media_query_service.dart';
import '../models/metadata_model.dart';
import '../models/music_model.dart';
import '../models/playlist_model.dart';
import '../utils/util.dart';
import 'database_service.dart';
import 'metadata_service.dart';

/// Media library service, globally.
///
/// Maintains all media, and interact with database.
class MediaLibraryService extends GetxService {
  final _databaseService = Get.find<DatabaseService>();
  final _metadataService = Get.find<MetadataService>();

  /// A special playlist contains all audio content as the library.
  final List<Playlist> allPlaylist = <Playlist>[].obs;

  final allMusic = Playlist().obs;

  // Save all [AudioModel] from Android media store.
  var _allAudioModel = <aq.AudioModel>[];

  /// Return the library.
  // Rx<Playlist> get allMusic => _allMusic;

  // Used for prevent same name playlist.
  String _lastTimeStamp = '';
  int _lastCount = 0;

  /// On use media store on Android, avoid to use tag readers for large mount of
  /// audios.
  /// If set to true, only use tag readers for extra information (e.g. bit rate)
  /// for single audio file and not use sqlite (we do not need such database).
  /// If set to true, scanning audios should only add audio files to android
  /// media store.
  /// Use as an experimental option.
  final androidOnlyUseMediaStore = true;

  /// Add audio content to library.
  ///
  /// If duplicate in content path, do nothing and return false.
  Future<bool> addContent(Music music) async {
    for (final content in allMusic.value.musicList) {
      if (content.filePath == music.filePath) {
        return false;
      }
    }
    // TODO: Fetch music and add to music library here.
    // _allContent.value.musicList.add(playContent);
    await allMusic.value.addMusic(music);
    return true;
  }

  /// Add a list of audio content.
  ///
  /// Return counts of content added.
  Future<int> addContentList(List<Music> playContentList) async {
    /// Count.
    var added = 0;
    for (final content in playContentList) {
      if (await addContent(content)) {
        added++;
      }
    }
    return added;
  }

  /// Add a playlist in library.
  Future<void> addPlaylist(Playlist playlistModel) async {
    return;
    allPlaylist.add(playlistModel);
    await _savePlaylist(playlistModel);
  }

  /// Remove a playlist, from library and from database.
  Future<void> removePlaylist(Playlist playlistModel) async {
    return;
  }

  /// Clear the library.
  void resetLibrary() {
    // _allContent.value.contentList.clear();
    // _resetPlaylistModel(_allContent.value);
  }

  /// Regenerate the table name and clear all audio contents.
  void _resetPlaylistModel(Playlist model) {
    // model
    //   ..clearMusicList()
    //   ..tableName = _regenerateTableName();
  }

  /// Init function, run before app start.
  Future<MediaLibraryService> init() async {
    /// Load audio from database.
    if (GetPlatform.isMobile) {
      if (androidOnlyUseMediaStore) {
        final queryService = Get.find<MediaQueryService>();
        _allAudioModel = queryService.audioList;
        return this;
      }
    }
    final allMusicFromDatabase = await _databaseService.storage.playlists
        .where()
        .nameEqualTo(libraryPlaylistName)
        .findFirst();
    if (allMusicFromDatabase != null) {
      await allMusicFromDatabase.musicList.load();
      allMusic.value = allMusicFromDatabase;
      print(
          'AAAA all music length = ${allMusic.value.musicList.length} ${allMusicFromDatabase.musicList.length}');
    }
    return this;
  }

  /// Save playlist to database.
  ///
  /// Library should also be saved because the [playlistModel] may be a new
  /// list and updated library may not haven't saved yet.
  Future<void> savePlaylist(Playlist playlistModel) async {
    await saveMediaLibrary();
    await _savePlaylist(playlistModel);
  }

  /// Save playlist to database.
  ///
  /// Save name, table name and audio content list.
  Future<void> _savePlaylist(Playlist playlistModel) async {}

  /// Save the library to database.
  ///
  /// Call this if any playlist changes.
  Future<void> saveMediaLibrary() async {
    // _allContent.value
    //   ..name = allMediaTableName
    //   ..tableName = allMediaTableName;
    // await _savePlaylist(_allContent.value);
  }

  /// Save library and all other playlists to database.
  Future<void> saveAllPlaylist() async {
    // await saveMediaLibrary();
    // for (final playlist in allPlaylist) {
    //   await _savePlaylist(playlist);
    // }
  }

  /// Generate playlist table name.
// String _regenerateTableName() {
//   final timeStamp = DateTime
//       .now()
//       .microsecondsSinceEpoch
//       .toString();
//   if (timeStamp == _lastTimeStamp) {
//     _lastCount++;
//   } else {
//     _lastTimeStamp = timeStamp;
//     _lastCount = 0;
//   }
//   return 'playlist_${timeStamp}_${_lastCount}_table';
// }

  /// Return the playlist with the given [tableName].
  @Deprecated('Use [findPlaylistById]')
  Playlist findPlaylistByTableName(String tableName) {
    // if (_allContent.value.tableName == tableName) {
    //   return _allContent.value;
    // }
    // for (final model in allPlaylist) {
    //   if (model.tableName == tableName) {
    //     return model;
    //   }
    // }
    return Playlist();
  }

  /// Find the [Playlist] with given [id].
  Future<Playlist?> findPlaylistById(int id) async =>
      _databaseService.storage.playlists.where().idEqualTo(id).findFirst();

// Music _fromDataMap(Map<String, dynamic> dataMap) =>
//     Music.fromData(
//       dataMap['path'],
//       dataMap['name'],
//       dataMap['size'],
//       dataMap['artist'],
//       dataMap['title'],
//       dataMap['track_number'],
//       dataMap['bit_rate'],
//       dataMap['album_artist'],
//       dataMap['album_title'],
//       dataMap['album_year'],
//       dataMap['album_track_count'],
//       dataMap['genre'],
//       dataMap['comment'],
//       dataMap['sample_rate'],
//       dataMap['channels'],
//       dataMap['length'],
//       dataMap['album_cover'],
//     );

  /// Find audio content from library (in memory) with specified file path.
  Music? findPlayContent(String contentPath) => null;

  // _allContent.value.find(contentPath);

  /// Find audio content from database (on disk) with specified file path.
  ///
  /// Not used yet.
  Future<Music?> findPlayContentFromDatabase(
    String contentPath,
    String playlistTableName,
  ) async {
    return null;
  }

  /// Add [folderPath] to monitor.
  ///
  /// After added, scan once to sync media data.
  /// TODO: Maybe should do a second diff scan because the first scan may took
  /// a long time and any update are invisible in first scan.
  Future<void> addMusicFolder(
    String folderPath, {
    bool parallel = true,
  }) async {
    late final List<Metadata> allData;
    if (!parallel) {
      final watch = Stopwatch()..start();
      allData = <Metadata>[];
      //
      final d = await Directory(folderPath).listAll();
      print('AAAA ${d.length}');
      for (final f in d) {
        if (f.statSync().type != FileSystemEntityType.file) {
          continue;
        }
        if (path.extension(f.path) != '.mp3') {
          continue;
        }
        final data = await _metadataService.readMetadata(f.path);
        if (data == null) {
          print('AAAA null metadata for path ${f.path}');
          continue;
        }
        allData.add(data);
      }
      print('AAAA addMusicFolder finish, count = ${allData.length}');
      print(
          'AAAA addMusicFolder finish, use ${watch.elapsed.inSeconds} seconds');
    } else {
      final watch = Stopwatch()..start();
      final d = await Directory(folderPath).listAll();
      allData = await _metadataService.readMetadataParallel(
        d
            .where(
              (entity) =>
                  entity.statSync().type == FileSystemEntityType.file &&
                  path.extension(entity.path) == '.mp3',
            )
            .map((entity) => entity.path)
            .toList(),
      );
      print('AAAA addMusicFolder finish, count = ${allData.length}');
      print(
          'AAAA addMusicFolder finish, use ${watch.elapsed.inSeconds} seconds');
    }

    // Save to music library playlist.
    final storage = Get.find<DatabaseService>().storage;
    final libraryPlaylist = await storage.playlists
        .where()
        .nameEqualTo(libraryPlaylistName)
        .findFirst();
    if (libraryPlaylist == null) {
      return;
    }
    for (final d in allData) {
      final music =
          await Get.find<MetadataService>().fetchMusic(d.filePath, metadata: d);
      // Save to database.
      await libraryPlaylist.addMusic(music);
      // Add to playlist.
      await allMusic.value.addMusic(music);
    }
    print('AAAA !!!!!!!!! add finish len=${allMusic.value.musicList.length}');
    allMusic.refresh();
    await storage.writeTxn(() async => storage.playlists.put(libraryPlaylist));
  }

  /// Remove [folderPath] from monitoring folders.
  /// Also remove all music stored in [folderPath] from music library playlist.
  Future<void> removeMusicFolder(String folderPath) async {
    await allMusic.value.removeMusicByMusicFolder(folderPath);
    allMusic.refresh();
  }
}
