import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:mpax_flutter/shared/models/models.dart';

/// Repository provides ability to access audio metadata.
abstract interface class MetadataRepository {
  /// Init the repository.
  ///
  /// Override this if needed.
  FutureOr<void> init();

  /// Dispose the repository.
  ///
  /// Override this if needed.
  FutureOr<void> dispose();

  /// Read metadata from file at [filePath].
  ///
  /// * Return [MusicModel] if read success.
  /// * Return error in String type when failed.
  Future<Either<String, MusicModel>> readMetadataFromFile(
    String filePath,
  );

  /// Read metadata from all files in [dirPath] and it's subdirectory.
  ///
  /// Convenience function to read from a directory.
  ///
  /// * Return a list of [MusicModel] and it's corresponding file path if
  ///   read succeed.
  /// * Return error in String type when failed to read any music format file
  ///   and [ignoreError] is true.
  /// * Return all read [MusicModel]s even failed on some files when
  ///   [ignoreError] is false.
  Future<Either<String, List<MusicModel>>> readMetadataFromDir(
    String dirPath, {
    bool ignoreError = false,
  });
}
