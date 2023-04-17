import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../models/album_model.dart';
import '../models/artist_model.dart';
import '../models/artwork_model.dart';
import '../models/artwork_with_type_model.dart';
import '../models/music_model.dart';
import '../models/playlist_model.dart';

/// Database storage service.
///
/// Provide methods related to database tables.
class DatabaseService extends GetxService {
  /// Music storage.
  late final Isar storage;

  /// Whether we need a rescan on all monitor folders.
  bool needRescanLibrary = false;

  /// Init function, run before app start.
  Future<DatabaseService> init() async {
    storage = await Isar.open(
      [
        AlbumSchema,
        ArtistSchema,
        ArtworkSchema,
        ArtworkWithTypeSchema,
        MusicSchema,
        PlaylistSchema,
      ],
      name: 'mpax',
      directory: '',
    );
    // Check where library playlist exists.
    // If not, create one.
    final libraryPlaylist = await storage.playlists
        .where()
        .nameEqualTo(libraryPlaylistName)
        .findFirst();
    if (libraryPlaylist == null) {
      needRescanLibrary = true;
      await storage.writeTxn(
        () async =>
            storage.playlists.put(Playlist()..name = libraryPlaylistName),
      );
    }
    return this;
  }

  /// Run a write transaction.
  Future<void> writeTxn(Future Function() callback) async {
    await storage.writeTxn(callback);
  }

  /// Save [Music] to database.
  Future<void> saveMusic(Music music) async {
    await storage.writeTxn(() async => storage.musics.put(music));
  }

  /// Save [Artist] to database.
  Future<void> saveArtist(Artist artist) async {
    await storage.writeTxn(() async => storage.artists.put(artist));
  }

  /// Save [Artwork] to database.
  Future<void> saveArtwork(Artwork artwork) async {
    await storage.writeTxn(() async => storage.artworks.put(artwork));
  }

  /// Save [ArtworkWithType] to database.
  Future<void> saveArtworkWithType(ArtworkWithType artworkWithType) async {
    await storage
        .writeTxn(() async => storage.artworkWithTypes.put(artworkWithType));
  }
}
