part of 'schema.dart';

/// Music table
@DataClassName('MusicEntity')
class Music extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  ////////// File raw info //////////
  /// File path.
  ///
  /// Unique key.
  TextColumn get filePath => text().unique()();

  /// File name.
  TextColumn get fileName => text()();

  ////////// Metadata //////////
  /// Only non-table metadata are stored here.
  /// Some table metadata types (e.g. artist/album) are
  /// stored in separate tables and keep a third table
  /// to record relationships between those table records
  /// and music records.

  /// Title.
  TextColumn get title => text().nullable()();

  /// Duration in milliseconds.
  IntColumn get duration => integer()();

  /// Album artists.
  ///
  /// Now is pure text.
  TextColumn get albumArtist => text().nullable()();
}
