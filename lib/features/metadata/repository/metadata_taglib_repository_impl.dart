import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:taglib_ffi_dart/taglib_ffi_dart.dart' as taglib;

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
      String filePath) async {
    // TODO: Test and implement.
    final data = await taglib.readMetadata(filePath);
    print(data);
    return Either<String, FileMetadataModel>.left('testing');
  }

  @override
  Future<Either<String, List<FileMetadataModel>>> readMetadataFromDir(
    String dirPath, {
    bool ignoreError = false,
  }) {
    // TODO: implement readMetadataFromFile
    throw UnimplementedError();
  }
}
