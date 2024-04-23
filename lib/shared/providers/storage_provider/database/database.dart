import 'package:drift/drift.dart';

import 'connection/native.dart';
import 'schema/schema.dart';

part 'database.g.dart';

/// The database definition in app.
@DriftDatabase(
  tables: [
    Album,
    Artist,
    Music,
    Playlist,
    MusicAlbumEntries,
    MusicArtistEntries,
    ArtistAlbumEntries,
    PlaylistMusicEntries,
    Settings,
  ],
)
final class AppDatabase extends _$AppDatabase {
  /// Constructor.
  AppDatabase() : super(connect());

  /// Constructor for test only.
  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;
}
