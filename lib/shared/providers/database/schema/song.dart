part of 'schema.dart';

@RealmModel()
class _Song {
  @PrimaryKey()
  late ObjectId id;

  ////////// File raw info //////////
  late String filePath;
  late String filename;

  ////////// Metadata //////////
  late String title;

  /// All objects id in [_Artist].
  late List<ObjectId> artists;

  /// Object id in [_Album].
  late ObjectId album;
}
