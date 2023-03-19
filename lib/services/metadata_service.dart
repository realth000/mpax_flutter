import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart' as mg;
import 'package:path/path.dart' as path;
import 'package:taglib_ffi/taglib_ffi.dart' as tl;

import '../models/play_content.model.dart';

/// Manage audio metadata, globally.
class MetadataService extends GetxService {
  /// Get a [PlayContent] filled with metadata read from given [contentPath].
  Future<PlayContent> readMetadata(
    String contentPath, {
    bool loadImage = false,
    bool scaleImage = true,
  }) async {
    final s = File(contentPath).statSync();
    if (s.type != FileSystemEntityType.file) {
      return PlayContent();
    }

    // Because metadata_god can load image and handles both utf8 and latin1
    // strings, use it on Windows and when need load cover images.
    // Because taglib_ffi can load sample rate, bitrate and ..., but can
    // not handle latin1 parameters, only use in utf8 environment and not need
    // cover images.
    if (Platform.isWindows && false) {
      late final mg.Metadata? metadata;
      try {
        metadata = await mg.MetadataGod.getMetadata(contentPath);
        if (metadata == null) {
          return PlayContent.fromPath(contentPath);
        }
        return _applyMetadataFromMG(
          contentPath,
          metadata,
          loadImage,
          scaleImage,
        );
      } catch (_) {
        // May have ffi exception.
        // Can not read metadata, maybe from m4a files.
        //   Only write basic info.
        //   TODO: Should print something here.
        return PlayContent.fromPath(contentPath);
      }
    } else {
      late final tl.Metadata? metadata;
      late final PlayContent playContent;
      try {
        metadata = await tl.TagLib(filePath: contentPath).readMetadataEx();
        if (metadata == null) {
          return PlayContent.fromPath(contentPath);
        }
        playContent = await _applyMetadataFromTL(
          contentPath,
          metadata,
          loadImage,
          scaleImage,
        );
        // final mgData = await mg.MetadataGod.getMetadata(contentPath);
        // if (mgData == null) {
        //   return playContent;
        // }
        // final mgPlayContent = await _applyMetadataFromMG(
        //     contentPath, mgData, loadImage, scaleImage);
        // playContent
        //   ..albumCover = mgPlayContent.albumCover ?? ''
        //   ..albumArtist = mgPlayContent.albumArtist ?? ''
        //   ..albumTrackCount = mgPlayContent.albumTrackCount ?? 0;
        return playContent;
      } catch (e) {
        //   TODO: Do something here.
        print('AAAA error: $e');
        return PlayContent.fromPath(contentPath);
      }
    }
  }

  /// Fetch metadata with package metadata_god.
  Future<PlayContent> _applyMetadataFromMG(
    String contentPath,
    mg.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final playContent = PlayContent.fromPath(contentPath);
    if (metadata.artist != null) {
      playContent.artist = metadata.artist!;
    }
    if (metadata.title != null) {
      playContent.title = metadata.title!;
    }
    if (playContent.title.isEmpty) {
      playContent.title = playContent.contentName;
    }
    if (metadata.trackNumber != null) {
      playContent.trackNumber = metadata.trackNumber!;
    }
    if (metadata.albumArtist != null) {
      playContent.albumArtist = metadata.albumArtist!;
    }
    if (metadata.album != null) {
      playContent.albumTitle = metadata.album!;
    }
    if (metadata.year != null) {
      playContent.albumYear = metadata.year!;
    }
    if (metadata.trackTotal != null) {
      playContent.albumTrackCount = metadata.trackTotal!;
    }
    // FIXME: Seems some files have a genre value ' ',
    // is blank but contains a space.
    // Do not know is id3 tag standard or file corruption or mis-edit,
    // just filter this situation now.
    if (metadata.genre != null && metadata.genre != ' ') {
      playContent.genre = metadata.genre!;
    }
    // if (metadata.bitrate != null) {
    //   playContent.bitRate = metadata.bitrate!;
    // }

    if (metadata.picture == null || !loadImage) {
      return playContent;
    }

    if (scaleImage && GetPlatform.isMobile) {
      final tmpList = await FlutterImageCompress.compressWithList(
        metadata.picture!.data,
        minWidth: 120,
        minHeight: 120,
      );
      playContent.albumCover = base64Encode(tmpList);
    } else if (!scaleImage) {
      playContent.albumCover = base64Encode(metadata.picture!.data);
    }
    return playContent;
  }

  /// Fetch metadata with package taglib_ffi.
  Future<PlayContent> _applyMetadataFromTL(
    String contentPath,
    tl.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final playContent = PlayContent.fromPath(contentPath);
    if (metadata.artist != null) {
      playContent.artist = metadata.artist!;
    }
    if (metadata.title != null) {
      playContent.title = metadata.title!;
    }
    if (playContent.title.isEmpty) {
      playContent.title = playContent.contentName;
    }
    if (metadata.track != null) {
      playContent.trackNumber = metadata.track!;
    }
//    if (metadata.albumArtist != null) {
//      playContent.albumArtist = metadata.albumArtist!;
//    }
    if (metadata.album != null) {
      playContent.albumTitle = metadata.album!;
    }
    if (metadata.year != null) {
      playContent.albumYear = metadata.year!;
    }
//    if (metadata.trackTotal != null) {
//      playContent.albumTrackCount = metadata.trackTotal!;
//    }
    // FIXME: Seems some files have a genre value ' ',
    // is blank but contains a space.
    // Do not know is id3 tag standard or file corruption or mis-edit,
    // just filter this situation now.
    if (metadata.genre != null && metadata.genre != ' ') {
      playContent.genre = metadata.genre!;
    }
    if (metadata.bitrate != null) {
      playContent.bitRate = metadata.bitrate!;
    }
    if (metadata.sampleRate != null) {
      playContent.sampleRate = metadata.sampleRate!;
    }
    if (metadata.channels != null) {
      playContent.channels = metadata.channels!;
    }
    if (metadata.length != null) {
      playContent.length = metadata.length!;
    }

    if (metadata.albumTotalTrack != 0) {
      playContent.albumTrackCount = metadata.albumTotalTrack!;
    }

    if (metadata.albumArtist != null) {
      playContent.albumArtist = metadata.albumArtist!;
    }

    if (metadata.albumCover != null && loadImage) {
      if (false) {
        playContent.albumCover = base64Encode(metadata.albumCover!);
      } else {
        if (scaleImage && GetPlatform.isMobile) {
          final tmpList = await FlutterImageCompress.compressWithList(
            metadata.albumCover!,
            minWidth: 120,
            minHeight: 120,
          );
          playContent.albumCover = base64Encode(tmpList);
        } else if (!scaleImage) {
          playContent.albumCover = base64Encode(metadata.albumCover!);
        }
      }
    }

    playContent.lyrics = metadata.lyrics ?? '';

    return playContent;
  }

  /// Load lyrics with given content.
  ///
  /// Load priority:
  /// 1. Lyrics in [content].
  /// 2. Lyrics in [content] file: reload lyrics from file.
  /// 3. Same name "*.lrc" file in same folder.
  /// 4. "<Artist> - <Title>.lrc" file in same folder.
  /// 5. User selected file.
  ///
  /// When [forceReload] is true, skip step 1.
  /// When [loadFilePath] is not null, only run step 5.
  Future<String> loadLyrics(
    PlayContent content, {
    bool? forceReload,
    String? loadFilePath,
  }) async {
    late String lyricsFilePath;
    late File lyricsFile;
    if (loadFilePath != null) {
      /// 5. User selected file.
      lyricsFile = File(loadFilePath);
      return lyricsFile.existsSync() ? await lyricsFile.readAsString() : '';
    }
    // 1. Lyrics in [content].
    if (content.lyrics.isNotEmpty && forceReload != null && !forceReload) {
      return content.lyrics;
    }
    // 2. Lyrics in [content] file: reload lyrics from file.
    final metadata = await readMetadata(content.contentPath);
    if (metadata.lyrics.isNotEmpty) {
      /// TODO: If lyrics are saved in database or we should consider save this
      /// data to somewhere, we need to save this.
      return metadata.lyrics;
    }
    final ext = path.extension(content.contentPath);
    // 3. Same name "*.lrc" file in same folder.
    lyricsFilePath = ext.isEmpty
        ? '${metadata.contentPath}.lrc'
        : metadata.contentPath
            .replaceAll(path.extension(metadata.contentPath), '.lrc');
    lyricsFile = File(lyricsFilePath);
    if (lyricsFile.existsSync()) {
      final s = await lyricsFile.readAsString();
      if (s.isNotEmpty) {
        return s;
      }
    }

    /// 4. "<Artist> - <Title>.lrc" file in same folder.
    if (content.title.isNotEmpty) {
      lyricsFilePath = content.artist.isEmpty
          ? '${path.dirname(content.contentPath)}/${content.title}.lrc'
          : '${path.dirname(content.contentPath)}/${content.artist} - ${content.title}.lrc';
      lyricsFile = File(lyricsFilePath);
      if (lyricsFile.existsSync()) {
        final s = await lyricsFile.readAsString();
        if (s.isNotEmpty) {
          return s;
        }
      }
    }
    return '';
  }

  /// Init function, run before app start.
  Future<MetadataService> init() async => this;
}
