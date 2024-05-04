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
  Future<Either<String, MetadataModel>> readMetadataFromFile(
    String filePath,
  ) async {
    // TODO: Test and implement.
    final data = await taglib.readMetadata(filePath);
    logger.e(data);
    return Either<String, MetadataModel>.left('testing');
  }

  @override
  Future<Either<String, List<MetadataModel>>> readMetadataFromDir(
    String dirPath, {
    bool ignoreError = false,
  }) async {
    final data = await taglib.readMetadataFromDir(dirPath);
    if (data == null) {
      return Either.left('failed to read metadata from $dirPath');
    }
    final metadataList = data.map(
      (e) => MetadataModel(
        filePath: e.filePath,
        fileName: path.basename(e.filePath),
        sourceDir: dirPath,
        title: e.title,
        artist: e.artist != null ? [e.artist!] : const [],
        album: e.album,
        track: e.track,
        year: e.year,
        genre: e.genre,
        comment: e.comment,
        sampleRate: e.sampleRate,
        bitrate: e.bitrate,
        channels: e.channels,
        duration: Duration(milliseconds: e.length ?? 0),
        albumArtist: e.albumArtist != null ? [e.albumArtist!] : const [],
        albumTotalTracks: e.albumTotalTrack,
        images: e.albumCover != null ? [e.albumCover!] : const [],
      ),
    );
    return Either.right(metadataList.toList());
  }
}
