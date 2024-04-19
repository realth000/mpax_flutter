part of 'models.dart';

/// Model of a group of metadata in a single music file source.
///
/// Now contains part of data defined Id3V2 format.
///
/// * Should contains all metadata we can have.
/// * Should only contain pure metadata data, without file info.
///   * e.g. Include [title] and [artist], exclude file path file size.
@MappableClass()
final class MetadataModel with MetadataModelMappable {
  /// Constructor.
  const MetadataModel({
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
  });

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

  /// Duration in seconds.
  ///
  /// Can not be null because it's part of property as a media file.
  final Duration duration;
}
