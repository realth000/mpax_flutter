import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart' as mg;
import 'package:path/path.dart' as path;
import 'package:taglib_ffi/taglib_ffi.dart' as tl;

import '../models/album_model.dart';
import '../models/music_model.dart';

/// Manage audio metadata, globally.
class MetadataService extends GetxService {
  ///
  Album fetchMetadata(
    title,
    artist, {
    String albumTitle,
  }) {}

  /// Get a [Music] filled with metadata read from given [filePath].
  Future<Music?> readMetadata(
    String filePath, {
    bool loadImage = false,
    bool scaleImage = true,
    bool fast = true,
  }) async {
    final s = File(filePath).statSync();
    if (s.type != FileSystemEntityType.file) {
      return null;
    }

    // Because metadata_god can load image and handles both utf8 and latin1
    // strings, use it on Windows and when need load cover images.
    // Because taglib_ffi can load sample rate, bitrate and ..., but can
    // not handle latin1 parameters, only use in utf8 environment and not need
    // cover images.
    if (fast) {
      late final mg.Metadata? metadata;
      try {
        metadata = await mg.MetadataGod.getMetadata(filePath);
        if (metadata == null) {
          return Music.fromPath(filePath);
        }
        return _applyMetadataFromMG(
          filePath,
          metadata,
          loadImage,
          scaleImage,
        );
      } catch (_) {
        // May have ffi exception.
        // Can not read metadata, maybe from m4a files.
        //   Only write basic info.
        //   TODO: Should print something here.
        return Music.fromPath(filePath);
      }
    } else {
      late final tl.Metadata? metadata;
      late final Music music;
      try {
        metadata = await tl.TagLib(filePath: filePath).readMetadataEx();
        if (metadata == null) {
          return Music.fromPath(filePath);
        }
        return await _applyMetadataFromTL(
          filePath,
          metadata,
          loadImage,
          scaleImage,
        );
      } catch (e) {
        //   TODO: Do something here.
        print('AAAA error: $e');
        return Music.fromPath(filePath);
      }
    }
  }

  /// Fetch metadata with package metadata_god.
  Future<Music> _applyMetadataFromMG(
    String contentPath,
    mg.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final music = Music.fromPath(contentPath);
    if (metadata.artist != null) {
      music.artist = metadata.artist!;
    }
    if (metadata.title != null) {
      music.title = metadata.title!;
    }
    if (music.title.isEmpty) {
      music.title = music.fileName;
    }
    if (metadata.trackNumber != null) {
      music.trackNumber = metadata.trackNumber!;
    }
    if (metadata.albumArtist != null) {
      music.albumArtist = metadata.albumArtist!;
    }
    if (metadata.album != null) {
      music.albumTitle = metadata.album!;
    }
    if (metadata.year != null) {
      music.albumYear = metadata.year!;
    }
    if (metadata.trackTotal != null) {
      music.albumTrackCount = metadata.trackTotal!;
    }
    // FIXME: Seems some files have a genre value ' ',
    // is blank but contains a space.
    // Do not know is id3 tag standard or file corruption or mis-edit,
    // just filter this situation now.
    if (metadata.genre != null && metadata.genre != ' ') {
      music.genre = metadata.genre!;
    }
    // if (metadata.bitrate != null) {
    //   playContent.bitRate = metadata.bitrate!;
    // }

    if (metadata.picture == null || !loadImage) {
      return music;
    }

    if (scaleImage && GetPlatform.isMobile) {
      final tmpList = await FlutterImageCompress.compressWithList(
        metadata.picture!.data,
        minWidth: 120,
        minHeight: 120,
      );
      music.albumCover = base64Encode(tmpList);
    } else if (!scaleImage) {
      music.albumCover = base64Encode(metadata.picture!.data);
    }
    return music;
  }

  /// Fetch metadata with package taglib_ffi.
  Future<Music> _applyMetadataFromTL(
    String contentPath,
    tl.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final playContent = Music.fromPath(contentPath);
    if (metadata.artist != null) {
      playContent.artist = metadata.artist!;
    }
    if (metadata.title != null) {
      playContent.title = metadata.title!;
    }
    if (playContent.title.isEmpty) {
      playContent.title = playContent.fileName;
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
    Music content, {
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
    final metadata = await readMetadata(content.filePath);
    if (metadata.lyrics.isNotEmpty) {
      /// TODO: If lyrics are saved in database or we should consider save this
      /// data to somewhere, we need to save this.
      return metadata.lyrics;
    }
    final ext = path.extension(content.filePath);
    // 3. Same name "*.lrc" file in same folder.
    lyricsFilePath = ext.isEmpty
        ? '${metadata.filePath}.lrc'
        : metadata.filePath
            .replaceAll(path.extension(metadata.filePath), '.lrc');
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
          ? '${path.dirname(content.filePath)}/${content.title}.lrc'
          : '${path.dirname(content.filePath)}/${content.artist} - ${content.title}.lrc';
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
