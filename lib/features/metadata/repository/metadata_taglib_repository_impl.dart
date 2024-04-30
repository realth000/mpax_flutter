import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:taglib_ffi_dart/taglib_ffi_dart.dart' as taglib;

import '../../../instance.dart';
import '../../../shared/models/models.dart';
import '../models/models.dart';
import 'metadata_repository.dart';

/// [MetadataRepository] implemented with taglib_ffi_dart.
///
/// Provide all metadata related ability with a taglib_ffi_dart backend.
final class MetadataTaglibRepositoryImpl implements MetadataRepository {
  @override
  FutureOr<void> init() async {
    await taglib.initialize();
  }

  @override
  FutureOr<void> dispose() {
    // Do nothing.
  }

  @override
  Future<Either<String, FileMetadataModel>> readMetadataFromFile(
    String filePath,
  ) async {
    // TODO: Test and implement.
    final data = await taglib.readMetadata(filePath);
    logger.e(data);
    return Either<String, FileMetadataModel>.left('testing');
  }

  @override
  Future<Either<String, List<FileMetadataModel>>> readMetadataFromDir(
    String dirPath, {
    bool ignoreError = false,
  }) async {
    final data = await taglib.readMetadataFromDir(dirPath);
    if (data == null) {
      return Either.left('failed to read metadata from $dirPath');
    }
    final metadataList = data.map(
      (e) => FileMetadataModel(
        '',
        MetadataModel(
          title: e.title,
          artist: e.artist != null ? [e.artist!] : const [],
          album: e.album,
          duration: Duration(seconds: e.length ?? 0),
        ),
      ),
    );
    return Either.right(metadataList.toList());
  }
}
