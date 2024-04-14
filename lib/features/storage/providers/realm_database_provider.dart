import 'package:mpax_flutter/features/storage/providers/storage_provider.dart';
import 'package:mpax_flutter/features/storage/schema/schema.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:realm/realm.dart';

/// Realm database provider.
///
/// Use realm to manage all audio related info.
final class RealmDatabaseProvider implements StorageProvider {
  /// Constructor.
  ///
  /// [path] is the database store path.
  RealmDatabaseProvider({String? path}) {
    config = Configuration.local(
      [
        Music.schema,
        Artist.schema,
        Album.schema,
        Playlist.schema,
      ],
      path: path,
    );
    realm = Realm(config);
  }

  /// Realm local configuration instance.
  ///
  /// Use it to initialize [realm].
  late LocalConfiguration config;

  /// Realm instance.
  late Realm realm;

  /// Dispose the provider and all its resources.
  @override
  void dispose() {
    realm.close();
  }

  Future<void> addMusic(MusicModel musicModel) async {
    final song = MusicKeys.fromModel(musicModel);
    await realm.writeAsync(() {
      realm.add<Music>(song);
      if (song.album != null) {
        realm.add<Album>(song.album!);
      }
      if (song.artists.isNotEmpty) {
        realm.addAll<Artist>(song.artists);
      }
    });
  }

  /// Find [Music] by its [id] or [filePath].
  ///
  /// Return null if not found.
  ///
  /// # Exception
  ///
  /// * [UnimplementedError]: If query field is not handled. This is an internal
  ///   error.
  @override
  Future<MusicModel?> findMusicByPath(String filePath) async {
    final song =
        await realm.query<Music>(MusicKeys.queryFromPath(filePath)).firstOrNull;
    if (song == null) {
      return null;
    }
    return MusicKeys.toModel(song);
  }

  /// Delete [Music] from database.
  ///
  /// This will not delete the file on disk.
  @override
  Future<void> deleteMusic(MusicModel musicModel) async {
    final song =
        realm.query<Music>(MusicKeys.queryFromModel(musicModel)).firstOrNull;
    if (song == null) {
      return;
    }
    await realm.writeAsync(() {
      realm.delete<Music>(song);
    });
  }
}
