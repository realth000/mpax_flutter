import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;
import 'package:sqflite/sqflite.dart';

import '../mobile/services/media_query_service.dart';
import '../models/music_model.dart';
import '../models/playlist_model.dart';

/// Media library service, globally.
///
/// Maintains all media, and interact with database.
class MediaLibraryService extends GetxService {
  /// Name of info table in database, contains all playlists' table's info.
  static const infoTableName = 'playlist_info_table';

  /// Database file name.
  static const databaseName = 'playlist.db';

  /// Table name of all media table.
  static const allMediaTableName = 'all_media';

  /// Info table columns.
  static const infoTableColumns =
      'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, sort INT, '
      'playlist_name TEXT, table_name TEXT';

  /// Playlist table columns.
  static const playlistTableColumns =
      'id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, path TEXT, name TEXT, size INT, '
      'title TEXT, artist TEXT, album_title TEXT, album_artist TEXT, '
      'album_year INT, album_track_count INT, track_number INT, bit_rate INT, '
      'sample_rate INT, genre TEXT, comment TEXT, channels INT, length INT, '
      'album_cover TEXT, lyrics TEXT';

  /// A special playlist contains all audio content as the library.
  final List<PlaylistModel> allPlaylist = <PlaylistModel>[].obs;

  final _allContent = PlaylistModel().obs;

  // Save all [AudioModel] from Android media store.
  var _allAudioModel = <aq.AudioModel>[];

  /// Return the library.
  PlaylistModel get allContentModel => _allContent.value;

  // Used for prevent same name playlist.
  String _lastTimeStamp = '';
  int _lastCount = 0;

  late final Future<Database> _database;

  /// Return library audio content list.
  List<Music> get content => _allContent.value.musicList;

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
  bool addContent(Music playContent) {
    for (final content in _allContent.value.musicList) {
      if (content.filePath == playContent.filePath) {
        return false;
      }
    }
    // TODO: Fetch music and add to music library here.
    // _allContent.value.musicList.add(playContent);
    return true;
  }

  /// Add a list of audio content.
  ///
  /// Return counts of content added.
  int addContentList(List<Music> playContentList) {
    /// Count.
    var added = 0;
    for (final content in playContentList) {
      if (addContent(content)) {
        added++;
      }
    }
    return added;
  }

  /// Add a playlist in library.
  Future<void> addPlaylist(PlaylistModel playlistModel) async {
    return;
    allPlaylist.add(playlistModel);
    await _savePlaylist(playlistModel);
  }

  /// Remove a playlist, from library and from database.
  Future<void> removePlaylist(PlaylistModel playlistModel) async {
    return;
    // allPlaylist
    //     .removeWhere((element) => element.tableName == playlistModel.tableName);
    // final db = await _database;
    // await db.delete(
    //   infoTableName,
    //   where: 'table_name = ?',
    //   whereArgs: <String>[playlistModel.tableName],
    // );
    // await db.execute('DROP TABLE ${playlistModel.tableName}');
  }

  /// Clear the library.
  void resetLibrary() {
    // _allContent.value.contentList.clear();
    // _resetPlaylistModel(_allContent.value);
  }

  /// Regenerate the table name and clear all audio contents.
  void _resetPlaylistModel(PlaylistModel model) {
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

        // Only use Android media store, not use sqlite database.
        // _allContent.value
        //   ..name = allMediaTableName
        //   ..tableName = allMediaTableName
        //   ..contentList.addAll(await queryService.allAudioContents());
        return this;
      }
      // _database = openDatabase(
      //   join(await getDatabasesPath(), databaseName),
      //   onCreate: (db, version) => db.execute(
      //     'CREATE TABLE IF NOT EXISTS $infoTableName($infoTableColumns);',
      //   ),
      //   version: 1,
      // );
    } else {
      // sqfliteFfiInit();
      // _database = databaseFactoryFfi.openDatabase(
      //   join('./', databaseName),
      //   options: OpenDatabaseOptions(
      //     onCreate: (db, version) => db.execute(
      //       'CREATE TABLE IF NOT EXISTS $infoTableName($infoTableColumns);',
      //     ),
      //     version: 1,
      //   ),
      // );
    }
    /*
    final db = await _database;
    // Fetch playlist data from database.
    // As created info table if not exists, no exception here.
    final List<Map<String, dynamic>> infoTable = await db.query(infoTableName);
    for (final table in infoTable) {
      final model = PlaylistModel()
        ..name = table['playlist_name']
        ..tableName = table['table_name'];
      final List<Map<String, dynamic>> playlistTable =
          await db.query(model.tableName);
      for (final playContent in playlistTable) {
        final c = _fromDataMap(playContent);
        model.contentList.add(c);
        if (model.tableName == allMediaTableName) {
          _allContent.value = model;
        } else {
          _allContent.value.contentList.add(c);
        }
      }

      if (model.tableName != allMediaTableName) {
        allPlaylist.add(model);
      }
    }
     */
    return this;
  }

  /// Save playlist to database.
  ///
  /// Library should also be saved because the [playlistModel] may be a new
  /// list and updated library may not haven't saved yet.
  Future<void> savePlaylist(PlaylistModel playlistModel) async {
    await saveMediaLibrary();
    await _savePlaylist(playlistModel);
  }

  /// Save playlist to database.
  ///
  /// Save name, table name and audio content list.
  Future<void> _savePlaylist(PlaylistModel playlistModel) async {
    /*
    if (playlistModel.tableName.isEmpty) {
      playlistModel.tableName = _regenerateTableName();
    }
    final db = await _database;
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS ${playlistModel.tableName}');
      // Not using truncate because table name may change like what qt version
      // does.
      await txn.delete(
        infoTableName,
        where: 'table_name = ?',
        whereArgs: <String>[playlistModel.tableName],
      );
      await txn.execute(
        'CREATE TABLE  ${playlistModel.tableName}($playlistTableColumns)',
      );
      await txn.insert(
        infoTableName,
        playlistModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      playlistModel.contentList.forEach((content) async {
        await txn.insert(
          playlistModel.tableName,
          content.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
     */
    /*
        The following for loop will throw exception:
        E/flutter (17641): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: Concurrent modification during iteration: Instance(length:255) of '_GrowableList'.
        E/flutter (17641): #0      ListIterator.moveNext (dart:_internal/iterable.dart:336:7)
        E/flutter (17641): #1      MediaLibraryService.savePlaylist.<anonymous closure> (package:mpax_flutter/services/media_library_service.dart:121:41)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #2      SqfliteDatabaseMixin._runTransaction (package:sqflite_common/src/database_mixin.dart:488:16)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #3      BasicLock.synchronized (package:synchronized/src/basic_lock.dart:33:16)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #4      SqfliteDatabaseMixin.txnSynchronized (package:sqflite_common/src/database_mixin.dart:344:14)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #5      MediaLibraryService.savePlaylist (package:mpax_flutter/services/media_library_service.dart:99:5)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #6      MediaLibraryService.saveMediaLibrary (package:mpax_flutter/services/media_library_service.dart:132:5)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #7      MediaLibraryService.saveAllPlaylist (package:mpax_flutter/services/media_library_service.dart:136:5)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641): #8      _ScanController.scanTargetList (package:mpax_flutter/views/scan_page.dart:119:5)
        E/flutter (17641): <asynchronous suspension>
        E/flutter (17641):
       */
    // for (var content in playlistModel.contentList) {
    //   await txn.insert(
    //     playlistModel.tableName,
    //     content.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace,
    //   );
    // }
  }

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
  PlaylistModel findPlaylistByTableName(String tableName) {
    // if (_allContent.value.tableName == tableName) {
    //   return _allContent.value;
    // }
    // for (final model in allPlaylist) {
    //   if (model.tableName == tableName) {
    //     return model;
    //   }
    // }
    return PlaylistModel();
  }

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
    // final db = await _database;
    // final List<Map<String, dynamic>> currentContent = await db.query(
    //   playlistTableName,
    //   where: 'path = ?',
    //   whereArgs: [contentPath],
    // );
    // if (currentContent.length != 1) {
    //   return null;
    // }
    // return _fromDataMap(currentContent[0]);
    return null;
  }

  /// Get a sorted playlist
  ///
  /// From database.
// Future<PlaylistModel> sortPlaylist(
//   PlaylistModel playlist,
//   String column,
//   String sort,
// ) async {
// final db = await _database;
// final model = PlaylistModel()
//   ..name = playlist.name
//   ..tableName = playlist.tableName;
// final List<Map<String, dynamic>> playlistTable = await db.query(
//   model.tableName,
//   orderBy: '$column $sort',
// );
// for (final playContent in playlistTable) {
//   final c = _fromDataMap(playContent);
//   model.contentList.add(c);
//   if (model.tableName == allMediaTableName) {
//     _allContent.value = model;
//   } else {
//     _allContent.value.contentList.add(c);
//   }
// }
// return model;
// }
}
