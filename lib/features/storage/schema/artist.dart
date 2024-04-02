part of 'schema.dart';

@RealmModel()
class _Artist {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  /// All objects in [_Song].
  late List<_Song> songs;

  /// All objects in [_Album].
  late List<_Album> albums;
}
