part of 'schema.dart';

@RealmModel()
class _Album {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  /// All objects in [_Artist].
  late Set<_Artist> artists;
}
