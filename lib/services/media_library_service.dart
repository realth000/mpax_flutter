import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MediaLibraryService extends GetxService {
  static const infoTableName = 'playlist_info_table';
  static const databaseName = 'playlist.db';

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
          'CREATE TABLE IF NOT EXISTS $infoTableName(id INT NOT NULL PRIMARY KEY, sort INT, playlist_name TEXT, table_name TEXT);',
        );
      },
      version: 1,
    );
    final db = await _database;
    // Fetch playlist data from database.
    final List<Map<String, dynamic>> infoTable = await db.query(infoTableName);
    for (var table in infoTable) {
      PlaylistModel model = PlaylistModel();
      model.name = table['playlist_name'];
      model.tableName = table['table_name'];
      final List<Map<String, dynamic>> playlistTable =
          await db.query(model.tableName);
      for (var playContent in playlistTable) {
        model.contentList.add(
          PlayContent.fromData(
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
          ),
        );
      }
    }
    return this;
  }

  Future<void> savePlaylist(PlaylistModel playlistModel) async {
    final db = await _database;
    await db.delete(playlistModel.tableName);
    await db.update(
      infoTableName,
      playlistModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    for (var content in playlistModel.contentList) {
      await db.insert(
        playlistModel.tableName,
        content.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
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
