part of 'schema.dart';

/// Artist table.
@DataClassName('ArtistEntity')
class Artist extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Artist name
  TextColumn get name => text()();

  /// Specify [name] can locate one unique [Playlist].
  @override
  List<Set<Column>> get uniqueKeys => [
        {name},
      ];
}
