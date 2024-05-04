part of 'schema.dart';

/// Album table
@DataClassName('AlbumEntity')
class Album extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Album title.
  TextColumn get title => text()();

  /// Album artists.
  TextColumn get artist => text().map(IntStringPairSet.converter).nullable()();

  /// All id and name pairs of [Music] belongs to this album.
  TextColumn get musicList => text().map(IntStringPairSet.converter)();

  /// Specify [title] and [artist] can locate one unique [Album].
  @override
  List<Set<Column>> get uniqueKeys => [
        {title, artist},
      ];
}
