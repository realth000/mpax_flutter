part of 'schema.dart';

/// Album table
class Album extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  /// Album title.
  TextColumn get title => text()();

  /// Album artists.
  TextColumn get artist => text()();

  /// Specify [title] and [artist] can locate one unique [Album].
  @override
  List<Set<Column>> get uniqueKeys => [
        {title, artist},
      ];
}
