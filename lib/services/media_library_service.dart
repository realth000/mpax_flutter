import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MediaLibraryService extends GetxService {
  static const infoTableName = 'playlist_info_table';
  static const databaseName = 'playlist.db';
  static const infoTableColumns =
      "id INT NOT NULL PRIMARY KEY, sort INT, playlist_name TEXT, table_name TEXT";
  static const playlistTableColumns =
      "id INT NOT NULL PRIMARY KEY, path TEXT, name TEXT, size INT, title TEXT,"
      "artist TEXT, album_title TEXT, album_artist TEXT, album_year INT, "
      "album_track_count INT, track_number INT, bit_rate INT, sample_rate INT, "
      "genre TEXT, comment TEXT, channels INT, length INT";

  List<PlaylistModel> _playlistModel = <PlaylistModel>[];
  PlaylistModel _allContentModel = PlaylistModel();

  PlaylistModel get allContentModel => _allContentModel;

  // Used for prevent same name playlist.
  String _lastTimeStamp = "";
  int _lastCount = 0;

  late final Future<Database> _database;

  List<PlayContent> get content => _allContentModel.contentList;

  bool addContent(PlayContent playContent) {
    if (_allContentModel.contentList.contains(playContent)) {
      return false;
    }
    _allContentModel.contentList.add(playContent);
    return true;
  }

  void resetLibrary() {
    _allContentModel.contentList.clear();
    _resetPlaylistModel(_allContentModel);
  }

  void _resetPlaylistModel(PlaylistModel model) {
    model.clearContent();
    model.tableName = _regenerateTableName();
    // print("!! GENERATED TABLE NAME ${model.tableName}");
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
      PlaylistModel model = PlaylistModel();
      model.name = table['playlist_name'];
      model.tableName = table['table_name'];
      final List<Map<String, dynamic>> playlistTable =
          await db.query(model.tableName);
      for (var playContent in playlistTable) {
        PlayContent c = PlayContent.fromData(
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
        );
        model.contentList.add(c);
        _allContentModel.contentList.add(c);
      }
    }
    return this;
  }

  Future<void> savePlaylist(PlaylistModel playlistModel) async {
    final db = await _database;
    await db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS ${playlistModel.tableName}');
      // Not using truncate because table name may change like what qt version does.
      await txn.delete(
        infoTableName,
        where: "table_name = ?",
        whereArgs: <String>[playlistModel.tableName],
      );
      await txn.execute(
          'CREATE TABLE  ${playlistModel.tableName}($playlistTableColumns)');
      await txn.insert(
        infoTableName,
        playlistModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (var content in playlistModel.contentList) {
        await txn.insert(
          playlistModel.tableName,
          content.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> saveMediaLibrary() async {
    await savePlaylist(_allContentModel);
  }

  Future<void> saveAllPlaylist() async {
    await saveMediaLibrary();
    for (var playlist in _playlistModel) {
      await savePlaylist(playlist);
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
    return "playlist_${timeStamp}_${_lastCount}_table";
  }
}
