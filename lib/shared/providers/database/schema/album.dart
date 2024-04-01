part of 'schema.dart';

@RealmModel()
class _Album {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  /// All objects id in [_Artist].
  late List<ObjectId> artists;

  /// All objects id in [_Song.
  late List<ObjectId> songs;
}
