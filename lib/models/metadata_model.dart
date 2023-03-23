import 'artwork_model.dart';

/// Temporary store audio metadata.
///
/// Maybe only used by [MetadataService].
class Metadata {
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
  Map<ArtworkType, Artwork>? artworkList;

  /// Lyrics string.
  ///
  /// Should including time and in *.lrc format.
  String? lyrics;
}
