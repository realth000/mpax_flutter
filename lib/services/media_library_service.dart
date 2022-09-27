import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MediaLibraryService extends GetxService {
  static const infoTableName = 'playlist_info_table';
  static const databaseName = 'playlist.db';
  static const allMediaTableName = 'all_media';
  static const infoTableColumns =
      'id INT NOT NULL PRIMARY KEY, sort INT, playlist_name TEXT, table_name TEXT';
  static const playlistTableColumns =
      'id INT NOT NULL PRIMARY KEY, path TEXT, name TEXT, size INT, title TEXT, '
      'artist TEXT, album_title TEXT, album_artist TEXT, album_year INT, '
      'album_track_count INT, track_number INT, bit_rate INT, sample_rate INT, '
      'genre TEXT, comment TEXT, channels INT, length INT, album_cover TEXT ';

  final List<PlaylistModel> allPlaylist = <PlaylistModel>[].obs;

  PlaylistModel _allContent = PlaylistModel();

  PlaylistModel get allContentModel => _allContent;

  // Used for prevent same name playlist.
  String _lastTimeStamp = '';
  int _lastCount = 0;

  late final Future<Database> _database;

  List<PlayContent> get content => _allContent.contentList;

  bool addContent(PlayContent playContent) {
    for (final content in _allContent.contentList) {
      if (content.contentPath == playContent.contentPath) {
        return false;
      }
    }
    _allContent.contentList.add(playContent);
    return true;
  }

  int addContentList(List<PlayContent> playContentList) {
    int added = 0;
    for (final content in playContentList) {
      if (addContent(content)) {
        added++;
      }
    }
    return added;
  }

  void addPlaylist(PlaylistModel playlistModel) {
    allPlaylist.add(playlistModel);
    _savePlaylist(playlistModel);
  }

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

  void resetLibrary() {
    _allContent.contentList.clear();
    _resetPlaylistModel(_allContent);
  }

  void _resetPlaylistModel(PlaylistModel model) {
    model.clearContent();
    model.tableName = _regenerateTableName();
  }

  Future<MediaLibraryService> init() async {
    // Load audio from storage (SQLite?)
    _database = openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE IF NOT EXISTS $infoTableName($infoTableColumns);',
        );
      },
      version: 1,
    );
    final db = await _database;
    // Fetch playlist data from database.
    // As created info table if not exists, no exception here.
    final List<Map<String, dynamic>> infoTable = await db.query(infoTableName);
    for (var table in infoTable) {
      final PlaylistModel model = PlaylistModel()
        ..name = table['playlist_name']
        ..tableName = table['table_name'];
      final List<Map<String, dynamic>> playlistTable =
          await db.query(model.tableName);
      for (var playContent in playlistTable) {
        final PlayContent c = PlayContent.fromData(
          playContent['path'],
          playContent['name'],
          playContent['size'],
          playContent['artist'],
          playContent['title'],
          playContent['track_number'],
          playContent['bit_rate'],
          playContent['album_artist'],
          playContent['album_title'],
          playContent['album_year'],
          playContent['album_track_count'],
          playContent['genre'],
          playContent['comment'],
          playContent['sample_rate'],
          playContent['channels'],
          playContent['length'],
          playContent['album_cover'],
        );
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

  Future<void> savePlaylist(PlaylistModel playlistModel) async {
    await saveMediaLibrary();
    await _savePlaylist(playlistModel);
  }

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

  Future<void> saveMediaLibrary() async {
    _allContent
      ..name = allMediaTableName
      ..tableName = allMediaTableName;
    await _savePlaylist(_allContent);
  }

  Future<void> saveAllPlaylist() async {
    await saveMediaLibrary();
    for (var playlist in allPlaylist) {
      await _savePlaylist(playlist);
    }
  }

  // As utils
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
}
