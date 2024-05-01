part of 'schema.dart';

/// Playlist table.
@DataClassName('PlaylistEntity')
class Playlist extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Playlist title.
  TextColumn get title => text()();

  /// Optional description.
  ///
  /// Default keep empty.
  TextColumn get description => text()();
}
