import 'dart:typed_data';

/// Temporary store audio metadata.
///
/// Maybe only used by MetadataService.
class Metadata {
  /// Default constructor.
  Metadata(this.filePath);

  Uint8List? firstImage() {
    return artworkFrontCover ??
        artworkDisc ??
        artworkBackCover ??
        artworkArtist ??
        artworkIcon ??
        artworkUnknown;
  }

  /// Music file path.
  String filePath;

  /// Title string.
  String? title;

  /// Artist name.
  String? artist;

  /// Album id.
  String? albumTitle;

  /// List of artist names.
  ///
  /// Need to convert to Artist type later.
  List<String> albumArtist = <String>[];

  /// Album year.
  int? albumYear;

  /// Album track count.
  int? albumTrackCount;

  /// Artwork in front cover.
  Uint8List? artworkFrontCover;

  /// Artwork in back cover.
  Uint8List? artworkBackCover;

  /// Artwork in front cover.
  Uint8List? artworkArtist;

  /// Artwork in disc.
  ///
  /// Most used.
  Uint8List? artworkDisc;

  /// Artwork in icon.
  Uint8List? artworkIcon;

  /// Artwork has unknown.
  ///
  /// Use as a default fallback image.
  Uint8List? artworkUnknown;

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
