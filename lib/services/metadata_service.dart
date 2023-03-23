import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart' as mg;
import 'package:path/path.dart' as path;
import 'package:taglib_ffi/taglib_ffi.dart' as tl;

import '../models/album_model.dart';
import '../models/artist_model.dart';
import '../models/artwork_model.dart';
import '../models/metadata_model.dart';
import '../models/music_model.dart';

/// Manage audio metadata, globally.
class MetadataService extends GetxService {
  /// Return a [Music].
  ///
  /// If exists a music with [filePath], return it.
  /// Otherwise make a new [Music].
  Music fetchMusic(
    String filePath,
  ) {
    throw UnimplementedError('Check, create or update Music here');
  }

  /// Return a [Artist].
  ///
  /// If exists an artist with [name], return it.
  /// Otherwise make a new [Artist].
  Artist fetchArtist(
    String name,
  ) {
    throw UnimplementedError('Check, create or update Artist here');
  }

  /// Return a [Album].
  ///
  /// If exists an album with [title] and [artists], return it.
  /// Otherwise make a new [Album].
  Album fetchAlbum(
    String title,
    List<String> artists, {
    String? albumTitle,
    int? albumTrackCount,
    Map<ArtworkType, Artwork>? artworkList,
  }) {
    throw UnimplementedError('Check, create or update Album here');
  }

  /// Return a [Artwork].
  ///
  /// If exists an artwork with [Artwork.dataHash] equals to hashed [data],
  /// return it.
  /// Otherwise make a new [Artwork].
  Artwork fetchArtwork(ArtworkFormat format, String data) {
    throw UnimplementedError('Check, create or return Artwork here');
  }

  /// Get a [Music] filled with metadata read from given [filePath].
  Future<Metadata?> readMetadata(
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
          return null;
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
        return null;
      }
    } else {
      late final tl.Metadata? metadata;
      late final Music music;
      try {
        metadata = await tl.TagLib(filePath: filePath).readMetadataEx();
        if (metadata == null) {
          return null;
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
        return null;
      }
    }
  }

  /// Fetch metadata with package metadata_god.
  Future<Metadata?> _applyMetadataFromMG(
    String contentPath,
    mg.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final ret = Metadata()
      ..artist = metadata.artist
      ..title = metadata.title
      ..track = metadata.trackNumber
      ..albumTrackCount = metadata.trackTotal
      ..albumTitle = metadata.album
      ..albumYear = metadata.year;
    if (metadata.albumArtist != null) {
      ret.albumArtist = <String>[metadata.albumArtist!];
    }
    if (metadata.genre != null && metadata.genre != ' ') {
      ret.genre = metadata.genre;
    }
    if (metadata.picture == null || !loadImage) {
      return ret;
    }

    if (scaleImage && GetPlatform.isMobile) {
      final tmpList = await FlutterImageCompress.compressWithList(
        metadata.picture!.data,
        minWidth: 120,
        minHeight: 120,
      );
      ret.artworkMap?[ArtworkType.unknown] = Artwork(
        format: metadata.picture!.mimeType.contains('png')
            ? ArtworkFormat.png
            : ArtworkFormat.jpeg,
        data: base64Encode(tmpList),
      );
    } else if (!scaleImage) {
      ret.artworkMap?[ArtworkType.unknown] = Artwork(
        format: metadata.picture!.mimeType.contains('png')
            ? ArtworkFormat.png
            : ArtworkFormat.jpeg,
        data: base64Encode(metadata.picture!.data),
      );
    }
    return ret;
  }

  /// Fetch metadata with package taglib_ffi.
  Future<Metadata?> _applyMetadataFromTL(
    String contentPath,
    tl.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final ret = Metadata()
      ..artist = metadata.artist
      ..title = metadata.title
      ..track = metadata.track
      ..albumTrackCount = metadata.albumTotalTrack
      ..albumTitle = metadata.album
      ..albumYear = metadata.year
      ..bitrate = metadata.bitrate
      ..sampleRate = metadata.sampleRate
      ..channels = metadata.channels
      ..length = metadata.length
      ..lyrics = metadata.lyrics
      ..comment = metadata.comment;
//    if (metadata.albumArtist != null) {
//      playContent.albumArtist = metadata.albumArtist!;
//    }
    // FIXME: Seems some files have a genre value ' ',
    // is blank but contains a space.
    // Do not know is id3 tag standard or file corruption or mis-edit,
    // just filter this situation now.
    if (metadata.albumArtist != null) {
      ret.albumArtist = <String>[metadata.albumArtist!];
    }
    if (metadata.genre != null && metadata.genre != ' ') {
      ret.genre = metadata.genre;
    }

    if (metadata.albumCover != null && loadImage) {
      if (scaleImage && GetPlatform.isMobile) {
        final tmpList = await FlutterImageCompress.compressWithList(
          metadata.albumCover!,
          minWidth: 120,
          minHeight: 120,
        );
        ret.artworkMap?[ArtworkType.unknown] = Artwork(
          /// FIXME: Add artwork format here.
          format: ArtworkFormat.jpeg,
          data: base64Encode(tmpList),
        );
      } else if (!scaleImage) {
        ret.artworkMap?[ArtworkType.unknown] = Artwork(
          /// FIXME: Add artwork format here.
          format: ArtworkFormat.jpeg,
          data: base64Encode(metadata.albumCover!),
        );
      }
    }

    return ret;
  }

  /// Load lyrics with given content.
  ///
  /// Load priority:
  /// 1. Lyrics in [music].
  /// 2. Lyrics in [music] file: reload lyrics from file.
  /// 3. Same name "*.lrc" file in same folder.
  /// 4. "<Artist> - <Title>.lrc" file in same folder.
  /// 5. User selected file.
  ///
  /// When [forceReload] is true, skip step 1.
  /// When [loadFilePath] is not null, only run step 5.
  Future<String?> loadLyrics(
    Music music, {
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
    if (music.lyrics != null &&
        music.lyrics!.isNotEmpty &&
        forceReload != null &&
        !forceReload) {
      return music.lyrics;
    }
    // 2. Lyrics in [content] file: reload lyrics from file.
    final metadata = await readMetadata(music.filePath);
    if (metadata != null &&
        metadata.lyrics != null &&
        metadata.lyrics!.isNotEmpty) {
      return metadata.lyrics;
    }
    final ext = path.extension(music.filePath);
    // 3. Same name "*.lrc" file in same folder.
    lyricsFilePath = ext.isEmpty
        ? '${music.filePath}.lrc'
        : music.filePath.replaceAll(path.extension(music.filePath), '.lrc');
    lyricsFile = File(lyricsFilePath);
    if (lyricsFile.existsSync()) {
      final s = await lyricsFile.readAsString();
      if (s.isNotEmpty) {
        return s;
      }
    }

    /// 4. "<Artist> - <Title>.lrc" file in same folder.
    if (music.title != null && music.title!.isNotEmpty) {
      lyricsFilePath = music.artists.isEmpty
          ? '${path.dirname(music.filePath)}/${music.title}.lrc'
          : '${path.dirname(music.filePath)}/${music.artists.join()} - ${music.title}.lrc';
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
