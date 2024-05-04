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
  TextColumn get description => text().nullable()();

  /// All id and name of [Music] in the playlist.
  TextColumn get musicList => text().map(IntStringPairSet.converter)();
}
