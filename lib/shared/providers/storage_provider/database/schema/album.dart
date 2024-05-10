part of 'schema.dart';

/// Album table.
///
/// Album's title and artist name is the unique key for a unique album.
///
/// Allow two or more albums have same title but different artist names, these
/// albums are treated as different albums.
@DataClassName('AlbumEntity')
class Album extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Album title.
  TextColumn get title => text()();

  /// Album artists.
  ///
  /// In album artist, we only store the artist's name, without id, because:
  ///
  /// * We do NOT know the id of artist when creating a new album record as
  ///   artist depends on album, album should record first.
  /// * The name of artist is the unique id of an artist. In other words we do
  ///   not allow same-name artists, all artists with the same name will be
  ///   regard as one artist. In fact same-name artists is impossible.
  ///
  /// The source string list of [StringSet] should be sorted before serialize
  /// into [StringSet].
  TextColumn get artist => text().map(StringSet.converter).nullable()();

  /// All id and name pairs of [Music] belongs to this album.
  TextColumn get musicList => text().map(IntStringPairSet.converter)();

  /// Specify [title] and [artist] can locate one unique [Album].
  @override
  List<Set<Column>> get uniqueKeys => [
        {title, artist},
      ];
}
