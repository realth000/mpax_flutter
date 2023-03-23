import 'artwork_model.dart';

/// Temporary store audio metadata.
///
/// Maybe only used by [MetadataService].
class Metadata {
  /// Default constructor.
  Metadata();

  /// Title string.
  String? title;

  /// Artist string.
  String? artist;

  /// Album title string.
  String? albumTitle;

  /// List of artist names.
  ///
  /// Need to convert to [Artist] type later.
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
