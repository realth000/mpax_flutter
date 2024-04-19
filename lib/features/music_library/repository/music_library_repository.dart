import 'package:fpdart/fpdart.dart';
import '../../../shared/models/models.dart';

/// Repository of music library bloc.
///
/// Provide ability to manage the music library.
abstract interface class MusicLibraryRepository {
  /// Load indexed data of [directory] from disk.
  ///
  /// # Return
  ///
  /// * A list of [MusicModel] if success.
  /// * A string if any error occurs.
  Future<Either<String, List<MusicModel>>> loadDirectoryData(String directory);

  /// Scan [directory], parse supported music files and construct into.
  ///
  /// # Return
  ///
  /// * A list of [MusicModel] if success.
  /// * A string if any error occurs.
  Future<Either<String, List<MusicModel>>> scanDirectory(String directory);

  /// Save [data] and [directory] info into music library.
  ///
  /// # Return
  ///
  /// * void if success.
  /// * A string if any error occurs.
  Future<Option<String>> saveDirectory(String directory, List<MusicModel> data);

  /// Remove [directory] from library.
  ///
  /// # Return
  ///
  /// * void if success.
  /// * A string if any error occurs.
  Future<Option<String>> removeDirectory(String directory);
}
