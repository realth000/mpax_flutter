import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:mpax_flutter/features/metadata/repository/metadata_repository.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:path/path.dart' as path;
import 'package:taglib_ffi_dart/taglib_ffi_dart.dart' as taglib;

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
  Future<Either<String, MusicModel>> readMetadataFromFile(
    String filePath,
  ) async {
    // TODO: Test and implement.
    final data = await taglib.readMetadata(filePath);
    logger.e(data);
    return Either<String, MusicModel>.left('testing');
  }

  @override
  Future<Either<String, List<MusicModel>>> readMetadataFromDir(
    String dirPath, {
    bool ignoreError = false,
  }) async {
    final data = await taglib.readMetadataFromDir(dirPath);
    if (data == null) {
      return Either.left('failed to read metadata from $dirPath');
    }
    final metadataList = data.map(
      (e) => MusicModel(
        filePath: e.filePath,
        filename: path.basename(e.filePath),
        title: e.title,
        artist: e.artist != null ? [e.artist!] : const [],
        album: e.album,
        albumArtist: e.albumArtist,
        duration: Duration(seconds: e.length ?? 0),
      ),
    );
    return Either.right(metadataList.toList());
  }
}
