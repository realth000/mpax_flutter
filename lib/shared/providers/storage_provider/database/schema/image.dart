part of 'schema.dart';

/// Image table.
///
/// Record all cached image relation records.
///
/// * Music image cover.
/// * Album image cover.
/// * Playlist image cover.
@DataClassName('ImageEntity')
class Image extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Cache file path.
  TextColumn get filePath => text().unique()();
}
