part of 'schema.dart';

/// Image table.
///
/// Record all cached image relation records.
///
/// * Music image cover.
/// * Album image cover.
/// * Artist avatar.
/// * Playlist image cover.
@DataClassName('ImageEntity')
class Image extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Cache file path.
  TextColumn get filePath => text().unique()();

  /// All ids of [Music] that use this image.
  TextColumn get musicList => text().map(IntSet.converter)();

  /// All ids of [Album] that use this image.
  TextColumn get albumList => text().map(IntSet.converter)();

  /// All ids of [Artist] that use this image.
  TextColumn get artistList => text().map(IntSet.converter)();

  /// All ids of [Playlist] that use this image.
  TextColumn get playlistList => text().map(IntSet.converter)();
}
