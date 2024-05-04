part of 'models.dart';

/// Model of a group of metadata in a single music file source.
///
/// Now contains part of data defined in Id3V2 format.
///
/// Similar to `MusicModel` but when we use this class, it means we are in some
/// places that before updating metadata info in database, so we do know nothing
/// about info saved in database:
///
/// * File at [filePath] is already recorded in database or not.
/// * What's the unique id of [filePath]/[artist]/[album] in database.
///
/// Only use this model in these situations.
@MappableClass()
final class MetadataModel with MetadataModelMappable {
  /// Constructor.
  const MetadataModel({
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

  ////////// File raw info //////////

  /// Full file path.
  final String filePath;

  /// File name.
  final String fileName;

  /// Mark the source dir.
  ///
  /// "This metadata is fetched when scanning [sourceDir]".
  final String sourceDir;

  ////////// Metadata //////////

  /// Music title.
  ///
  /// Can be null.
  final String? title;

  /// All artists' name.
  ///
  /// Can be empty, but not null.
  final List<String> artist;

  /// Album name.
  ///
  /// Can be null.
  final String? album;

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
  final Duration? duration;

  /// Album artist id and name.
  final List<String> albumArtist;

  /// All tracks count in album.
  final int? albumTotalTracks;

  /// Cover images id;
  final List<Uint8List>? images;
}
