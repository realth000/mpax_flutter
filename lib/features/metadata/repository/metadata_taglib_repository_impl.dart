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
  Stream<MetadataModel> readMetadataStreamFromDir(
    String dirPath, {
    bool ignoreError = false,
  }) async* {
    logger.i('loading metadata from directory $dirPath');
    yield* taglib.readMetadataStreamFromDir(dirPath).asyncMap((d) async {
      final e = await d;
      return MetadataModel(
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
        duration: Duration(milliseconds: e.lengthInSeconds ?? 0),
        albumArtist: e.albumArtist != null ? [e.albumArtist!] : const [],
        albumTotalTracks: e.albumTotalTrack,
        images: e.albumCover != null ? [e.albumCover!] : const [],
      );
    });
  }
}
