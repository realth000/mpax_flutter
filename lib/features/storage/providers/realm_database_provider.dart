import 'package:mpax_flutter/features/storage/providers/database_provider.dart';
import 'package:mpax_flutter/features/storage/schema/schema.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:realm/realm.dart';

/// Realm database provider.
///
/// Use realm to manage all audio related info.
final class RealmDatabaseProvider implements DatabaseProvider {
  /// Constructor.
  ///
  /// [path] is the database store path.
  RealmDatabaseProvider({String? path}) {
    config = Configuration.local(
      [
        Song.schema,
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

  Future<void> addSong(SongModel songModel) async {
    final song = SongKeys.fromModel(songModel);
    await realm.writeAsync(() {
      realm.add<Song>(song);
      if (song.album != null) {
        realm.add<Album>(song.album!);
      }
      if (song.artists.isNotEmpty) {
        realm.addAll<Artist>(song.artists);
      }
    });
  }

  /// Find [Song] by its [id] or [filePath].
  ///
  /// Return null if not found.
  ///
  /// # Exception
  ///
  /// * [UnimplementedError]: If query field is not handled. This is an internal
  ///   error.
  @override
  Future<SongModel?> findSongByPath(String filePath) async {
    final song =
        await realm.query<Song>(SongKeys.queryFromPath(filePath)).firstOrNull;
    if (song == null) {
      return null;
    }
    return SongKeys.toModel(song);
  }

  /// Delete [song] from database.
  ///
  /// This will not delete the file on disk.
  @override
  Future<void> deleteSong(SongModel songModel) async {
    final song =
        realm.query<Song>(SongKeys.queryFromModel(songModel)).firstOrNull;
    if (song == null) {
      return;
    }
    await realm.writeAsync(() {
      realm.delete<Song>(song);
    });
  }
}
