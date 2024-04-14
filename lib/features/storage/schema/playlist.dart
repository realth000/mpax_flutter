part of 'schema.dart';

@RealmModel()
class _Playlist {
  @PrimaryKey()
  late ObjectId id;

  late String name;

  /// All objects in [_Music].
  late Set<_Music> musics;
}
