part of 'schema.dart';

/// Music table
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
  /// Title.
  TextColumn get title => text()();

  /// Specify [filePath] can locate one unique [Music].
  @override
  List<Set<Column>> get uniqueKeys => [
        {filePath},
      ];
}
