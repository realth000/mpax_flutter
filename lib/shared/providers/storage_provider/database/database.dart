import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/connection/native.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

part 'database.g.dart';

/// The database definition in app.
@DriftDatabase(
  tables: [
    Album,
    Artist,
    Image,
    Music,
    Playlist,
    MusicAlbumEntries,
    MusicArtistEntries,
    ArtistAlbumEntries,
    PlaylistMusicEntries,
    MusicImageEntries,
    AlbumImageEntries,
    PlaylistImageEntries,
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
