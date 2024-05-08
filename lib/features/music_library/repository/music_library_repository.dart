import 'package:fpdart/fpdart.dart';
import 'package:mpax_flutter/shared/models/models.dart';

/// Repository of music library bloc.
///
/// Provide ability to manage the music library.
abstract interface class MusicLibraryRepository {
  /// Load indexed data of [directory] from storage.
  ///
  /// # Return
  ///
  /// * A list of [MusicModel] if success.
  /// * A string if any error occurs.
  Future<Either<String, List<MusicModel>>> loadDirectoryFromStorage(
    String directory,
  );

  /// Load all indexed data from storage.
  ///
  /// # Return
  ///
  /// * A list of [MusicModel] that contains all indexed data if success.
  /// * A string if any error occurs.
  Future<Either<String, List<MusicModel>>> loadAllDirectoryFromStorage();

  /// Save a list of [MetadataModel] to storage.
  ///
  /// # Return
  ///
  /// * A list of [MusicModel] if success.
  /// * A string if any error occurs.
  Future<Either<String, MusicModel>> saveMetadataToStorage(
    MetadataModel metadataModel,
  );

  /// Remove [directory] from library.
  ///
  /// # Return
  ///
  /// * void if success.
  /// * A string if any error occurs.
  Future<Option<String>> removeDirectoryFromStorage(String directory);
}
