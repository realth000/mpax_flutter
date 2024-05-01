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

  /// Upsert.
  Future<int> upsertPlaylist(PlaylistCompanion playlistCompanion) async {
    return into(playlist).insertOnConflictUpdate(playlistCompanion);
  }

  /// Delete the unique [Playlist] by [id].
  Future<int> deletePlaylist(int id) async {
    return (delete(playlist)..where((x) => x.id.equals(id))).go();
  }
}
