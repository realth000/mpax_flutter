import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

part 'playlist.g.dart';

/// DAO of table [Music].
@DriftAccessor(tables: [Playlist])
final class PlaylistDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistDaoMixin {
  /// Constructor.
  PlaylistDao(super.db);

  /// Select all [Playlist] those [Playlist.title] is [title].
  Future<List<PlaylistEntity>> selectPlaylistByTitle(String title) async {
    return (select(playlist)..where((x) => x.title.equals(title))).get();
  }

  /// Insert.
  Future<int> insertPlaylist(PlaylistCompanion playlistCompanion) async {
    return into(playlist).insert(playlistCompanion);
  }

  /// Update.
  ///
  /// Write [playlistCompanion], all absent fields will not change.
  Future<int> updatePlaylistIgnoreAbsent(
    int id,
    PlaylistCompanion playlistCompanion,
  ) async {
    return (update(playlist)..where((e) => e.id.equals(id)))
        .write(playlistCompanion);
  }

  /// Update.
  ///
  /// Replace with [playlistEntity], save all absents fields.
  Future<bool> replacePlaylist(PlaylistEntity playlistEntity) async {
    return update(playlist).replace(playlistEntity);
  }

  /// Upsert.
  Future<int> upsertPlaylist(PlaylistCompanion playlistCompanion) async {
    return into(playlist).insertOnConflictUpdate(playlistCompanion);
  }

  /// Delete the unique [Playlist] by [id].
  Future<int> deletePlaylist(int id) async {
    return (delete(playlist)..where((x) => x.id.equals(id))).go();
  }
}
