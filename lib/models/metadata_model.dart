import 'dart:convert';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/utils/debug.dart';
import 'package:mpax_flutter/utils/platform.dart';
import 'package:taglib_ffi/taglib_ffi.dart' as taglib;

/// Temporary store audio metadata.
///
/// Maybe only used by MetadataService.
class Metadata {
  /// Default constructor.
  Metadata(this.filePath);

  Future<void> fetch({bool scaleImage = true}) async {
    final metadata = await taglib.TagLib(filePath: filePath).readMetadataEx();
    if (metadata == null) {
      return;
    }
    debug('get metadata: ${metadata.title}, ${metadata.artist}');
    title = metadata.title;
    artist = metadata.artist;
    albumTitle = metadata.album;
    if (albumArtist != null && metadata.albumArtist != null) {
      albumArtist!.clear();
      albumArtist!.add(metadata.albumArtist!);
    }
    track = metadata.track;
    albumTrackCount = metadata.albumTotalTrack;
    albumYear = metadata.year;
    genre = metadata.genre;
    comment = metadata.comment;
    sampleRate = metadata.sampleRate;
    bitrate = metadata.bitrate;
    channels = metadata.channels;
    length = metadata.length;
    lyrics = metadata.lyrics;
    if (metadata.albumCover != null) {
      artworkMap ??= <ArtworkType, Artwork>{};

      if (scaleImage && isMobile) {
        final data = await FlutterImageCompress.compressWithList(
          metadata.albumCover!,
          minWidth: 120,
          minHeight: 120,
        );
        final artwork =
            Artwork(format: ArtworkFormat.jpeg, data: base64Encode(data));
        artworkMap![ArtworkType.unknown] = artwork;
      } else {
        final artwork = Artwork(
          format: ArtworkFormat.jpeg,
          data: base64Encode(metadata.albumCover!),
        );
        artworkMap![ArtworkType.unknown] = artwork;
      }
    }
  }

  /// Music file path.
  String filePath;

  /// Title string.
  String? title;

  /// Artist string.
  String? artist;

  /// Album title string.
  String? albumTitle;

  /// List of artist names.
  ///
  /// Need to convert to Artist type later.
  List<String>? albumArtist;

  /// Album year.
  int? albumYear;

  /// Album track count.
  int? albumTrackCount;

  /// Artwork map.
  ///
  /// Unknown type (position) artwork should <= 1.
  Map<ArtworkType, Artwork>? artworkMap;

  /// Music genre.
  String? genre;

  /// Audio track number.
  int? track;

  /// Audio bit rate.
  int? bitrate;

  /// Audio sample rate.
  int? sampleRate;

  /// Channels count, usually 2.
  int? channels;

  /// Audio length, should in seconds.
  int? length;

  /// Lyrics string.
  ///
  /// Should including time and in *.lrc format.
  String? lyrics;

  /// Comment string.
  String? comment;
}
