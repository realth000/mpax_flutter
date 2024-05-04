part of 'models.dart';

/// Model of song used in app.
@MappableClass()
final class MusicModel with MusicModelMappable {
  /// Constructor.
  const MusicModel({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.sourceDir,
    required this.title,
    required this.artist,
    required this.album,
    required this.track,
    required this.year,
    required this.genre,
    required this.comment,
    required this.sampleRate,
    required this.bitrate,
    required this.channels,
    required this.duration,
    required this.albumArtist,
    required this.albumTotalTracks,
    required this.images,
  });

  /// Unique id.
  final int id;

  ////////// File raw info //////////

  /// File full path.
  final String filePath;

  /// File name, for convenience use.
  final String fileName;

  /// Source dir path.
  final String sourceDir;

  ////////// Metadata //////////

  /// Title.
  final String? title;

  /// Artist id and name.
  final ArtistDbInfoSet? artist;

  /// Album id and title.
  final AlbumDbInfo? album;

  /// Track number in the album.
  final int? track;

  /// Publish year.
  final int? year;

  /// Genre name.
  final String? genre;

  /// Comment.
  final String? comment;

  /// Sample rate.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  final int? sampleRate;

  /// Bitrate.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  final int? bitrate;

  /// Channels number.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  final int? channels;

  /// Duration in milliseconds.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  final int? duration;

  /// Album artist id and name.
  final ArtistDbInfoSet? albumArtist;

  /// All tracks count in album.
  final int? albumTotalTracks;

  /// Cover images id;
  final ImageDbInfoSet? images;
}
