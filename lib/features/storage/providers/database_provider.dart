import 'package:mpax_flutter/shared/models/models.dart';

/// Interface of database.
///
/// All database source should implement this class to ensure providing
/// all required ability.
abstract interface class DatabaseProvider {
  Future<void> addSong(SongModel songModel);

  Future<SongModel?> findSongByPath(String filePath);

  Future<void> deleteSong(SongModel songModel);

  void dispose() {}
}
