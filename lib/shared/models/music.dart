part of 'models.dart';

/// Model of song used in all.
@MappableClass()
final class MusicModel with MusicModelMappable {
  /// Constructor.
  const MusicModel({
    required this.filePath,
    required this.filename,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.albumArtist,
  });

  ////////// File raw info //////////

  /// File full path.
  final String filePath;

  /// File name, for convenience use.
  final String filename;

  ////////// Metadata //////////

  /// Title.
  final String? title;

  /// Artist
  final List<String> artist;

  /// Album title
  final String? album;

  /// Music duration.
  final Duration duration;

  // TODO: Use List<String>
  /// Album artist.
  final String? albumArtist;
}
