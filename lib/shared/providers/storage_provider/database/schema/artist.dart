part of 'schema.dart';

/// Artist table.
///
/// Artist name is the identity for an unique artist record.
///
/// Do NOT allow two or more artist have the same name, treated as a same
/// artist.
@DataClassName('ArtistEntity')
class Artist extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Artist name
  TextColumn get name => text()();

  /// All id and name pairs of [Music] belongs to this artist.
  TextColumn get musicList => text().map(IntStringPairSet.converter)();

  /// All id and title pairs of [Album] belongs to this artist.
  TextColumn get albumList => text().map(IntStringPairSet.converter)();

  /// Specify [name] can locate one unique [Playlist].
  @override
  List<Set<Column>> get uniqueKeys => [
        {name},
      ];
}
