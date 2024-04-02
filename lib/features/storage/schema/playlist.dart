part of 'schema.dart';

@RealmModel()
class _Playlist {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  /// All objects in [_Song].
  late List<_Song> songs;

  /// All objects in [_Artist].
  late List<_Artist> artists;
}
