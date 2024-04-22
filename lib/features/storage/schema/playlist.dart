part of 'schema.dart';

/// Playlist table.
class Playlist extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Playlist title.
  TextColumn get title => text()();
}
