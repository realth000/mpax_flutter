part of 'schema.dart';

@RealmModel()
class _Artist {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  /// All objects id in [_Song].
  late List<ObjectId> songs;

  /// All objects id in [_Album].
  late List<ObjectId> albums;
}
