import '../../../shared/models/models.dart';

/// Interface of database.
///
/// All database source should implement this class to ensure providing
/// all required ability.
abstract interface class StorageProvider {
  Future<void> addMusic(MusicModel musicModel);

  Future<MusicModel?> findMusicByPath(String filePath);

  Future<void> deleteMusic(MusicModel musicModel);

  void dispose() {}
}
