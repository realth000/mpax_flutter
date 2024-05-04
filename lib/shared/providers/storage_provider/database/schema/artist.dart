part of 'schema.dart';

/// Artist table.
@DataClassName('ArtistEntity')
class Artist extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Artist name
  TextColumn get name => text()();

  /// All id and name pairs of [Music] belongs to this artist.
  TextColumn get musicList => text().map(IntStringPairSet.converter)();

  /// Specify [name] can locate one unique [Playlist].
  @override
  List<Set<Column>> get uniqueKeys => [
        {name},
      ];
}
