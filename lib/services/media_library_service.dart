import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/play_content.model.dart';
import '../models/playlist.model.dart';

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
  static const infoTableColumns = 'id INT NOT NULL PRIMARY KEY, sort INT, '
      'playlist_name TEXT, table_name TEXT';

  /// Playlist table columns.
  static const playlistTableColumns =
      'id INT NOT NULL PRIMARY KEY, path TEXT, name TEXT, size INT, '
      'title TEXT, artist TEXT, album_title TEXT, album_artist TEXT, '
      'album_year INT, album_track_count INT, track_number INT, bit_rate INT, '
      'sample_rate INT, genre TEXT, comment TEXT, channels INT, length INT, '
      'album_cover TEXT ';

  /// A special playlist contains all audio content as the library.
  final List<PlaylistModel> allPlaylist = <PlaylistModel>[].obs;

  PlaylistModel _allContent = PlaylistModel();

  /// Return the library.
  PlaylistModel get allContentModel => _allContent;

  // Used for prevent same name playlist.
  String _lastTimeStamp = '';
  int _lastCount = 0;

  late final Future<Database> _database;

  /// Return library audio content list.
  List<PlayContent> get content => _allContent.contentList;

  /// Add audio content to library.
  ///
  /// If duplicate in content path, do nothing and return false.
  bool addContent(PlayContent playContent) {
    for (final content in _allContent.contentList) {
      if (content.contentPath == playContent.contentPath) {
        return false;
      }
    }
    _allContent.contentList.add(playContent);
    return true;
  }

  /// Add a list of audio content.
  ///
  /// Return counts of content added.
  int addContentList(List<PlayContent> playContentList) {
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
    allPlaylist.add(playlistModel);
    await _savePlaylist(playlistModel);
  }

  /// Remove a playlist, from library and from database.
  Future<void> removePlaylist(PlaylistModel playlistModel) async {
    allPlaylist
        .removeWhere((element) => element.tableName == playlistModel.tableName);
    final db = await _database;
    await db.delete(
      infoTableName,
      where: 'table_name = ?',
      whereArgs: <String>[playlistModel.tableName],
    );
    await db.execute('DROP TABLE ${playlistModel.tableName}');
  }

  /// Clear the library.
  void resetLibrary() {
    _allContent.contentList.clear();
    _resetPlaylistModel(_allContent);
  }

  /// Regenerate the table name and clear all audio contents.
  void _resetPlaylistModel(PlaylistModel model) {
    model
      ..clearContent()
      ..tableName = _regenerateTableName();
  }

  /// Init function, run before app start.
  Future<MediaLibraryService> init() async {
    /// Load audio from database.
    _database = openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE IF NOT EXISTS $infoTableName($infoTableColumns);',
      ),
      version: 1,
    );
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
          _allContent = model;
        } else {
          _allContent.contentList.add(c);
        }
      }

      if (model.tableName != allMediaTableName) {
        allPlaylist.add(model);
      }
    }
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
    });
  }

  /// Save the library to database.
  ///
  /// Call this if any playlist changes.
  Future<void> saveMediaLibrary() async {
    _allContent
      ..name = allMediaTableName
      ..tableName = allMediaTableName;
    await _savePlaylist(_allContent);
  }

  /// Save library and all other playlists to database.
  Future<void> saveAllPlaylist() async {
    await saveMediaLibrary();
    for (final playlist in allPlaylist) {
      await _savePlaylist(playlist);
    }
  }

  /// Generate playlist table name.
  String _regenerateTableName() {
    final timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    if (timeStamp == _lastTimeStamp) {
      _lastCount++;
    } else {
      _lastTimeStamp = timeStamp;
      _lastCount = 0;
    }
    return 'playlist_${timeStamp}_${_lastCount}_table';
  }

  /// Return the playlist with the given [tableName].
  PlaylistModel findPlaylistByTableName(String tableName) {
    if (_allContent.tableName == tableName) {
      return _allContent;
    }
    for (final model in allPlaylist) {
      if (model.tableName == tableName) {
        return model;
      }
    }
    return PlaylistModel();
  }

  PlayContent _fromDataMap(Map<String, dynamic> dataMap) =>
      PlayContent.fromData(
        dataMap['path'],
        dataMap['name'],
        dataMap['size'],
        dataMap['artist'],
        dataMap['title'],
        dataMap['track_number'],
        dataMap['bit_rate'],
        dataMap['album_artist'],
        dataMap['album_title'],
        dataMap['album_year'],
        dataMap['album_track_count'],
        dataMap['genre'],
        dataMap['comment'],
        dataMap['sample_rate'],
        dataMap['channels'],
        dataMap['length'],
        dataMap['album_cover'],
      );

  /// Find audio content from library (in memory) with specified file path.
  PlayContent? findPlayContent(String contentPath) =>
      _allContent.find(contentPath);

  /// Find audio content from database (on disk) with specified file path.
  ///
  /// Not used yet.
  Future<PlayContent?> findPlayContentFromDatabase(
    String contentPath,
    String playlistTableName,
  ) async {
    final db = await _database;
    final List<Map<String, dynamic>> currentContent = await db.query(
      playlistTableName,
      where: 'path = ?',
      whereArgs: [contentPath],
    );
    if (currentContent.length != 1) {
      return null;
    }
    return _fromDataMap(currentContent[0]);
  }
}
