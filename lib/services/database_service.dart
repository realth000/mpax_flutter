import 'dart:async';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/album_model.dart';
import 'package:mpax_flutter/models/artist_model.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/models/artwork_with_type_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

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
    final databaseDirectory =
        await path_provider.getApplicationSupportDirectory();
    if (!databaseDirectory.existsSync()) {
      await databaseDirectory.create();
    }
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
      directory: databaseDirectory.path,
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
    await storage.writeTxn<void>(callback);
  }

  /// Save [Music] to database.
  Future<void> saveMusic(Music music) async {
    await storage.writeTxn(() async => storage.musics.putByFilePath(music));
  }

  /// Save [Artist] to database.
  Future<void> saveArtist(Artist artist) async {
    await storage.writeTxn(() async => storage.artists.putByName(artist));
  }

  /// Save [Artwork] to database.
  Future<void> saveArtwork(Artwork artwork) async {
    await storage.writeTxn(() async => storage.artworks.putByDataHash(artwork));
  }

  /// Save [ArtworkWithType] to database.
  Future<void> saveArtworkWithType(ArtworkWithType artworkWithType) async {
    await storage
        .writeTxn(() async => storage.artworkWithTypes.put(artworkWithType));
  }

  String? findArtworkDataByTypeIdSync(Id? id) {
    if (id == null) {
      return null;
    }
    final awt = storage.artworkWithTypes.where().idEqualTo(id).findFirstSync();
    if (awt == null) {
      return null;
    }
    return storage.artworks.where().idEqualTo(awt.id).findFirstSync()?.data;
  }

  Future<Music?> findMusicById(Id? id) async {
    if (id == null) {
      return null;
    }
    return storage.musics.where().idEqualTo(id).findFirst();
  }

  Future<Music?> findMusicByFilePath(String filePath) async {
    return storage.musics.where().filePathEqualTo(filePath).findFirst();
  }

  Future<String> findArtistNamesByIdList(List<Id> idList) async {
    final artistList = idList
        .map((e) async => storage.artists.where().idEqualTo(e).findFirst())
        .join(' - ');
    if (artistList.isEmpty) {
      return '';
    } else {
      return artistList;
    }
  }

  String findArtistNamesByIdListSync(List<Id> idList) {
    final artistList = idList
        .map((e) => storage.artists.where().idEqualTo(e).findFirstSync())
        .join(' - ');
    if (artistList.isEmpty) {
      return '';
    } else {
      return artistList;
    }
  }

  Future<Album?> findAlbumById(Id? id) async {
    if (id == null) {
      return null;
    }
    return storage.albums.where().idEqualTo(id).findFirst();
  }

  Album? findAlbumByIdSync(Id? id) {
    if (id == null) {
      return null;
    }
    return storage.albums.where().idEqualTo(id).findFirstSync();
  }

  Future<String> findAlbumTitleById(Id? id) async {
    final album = await findAlbumById(id);
    if (album == null) {
      return '';
    }
    return album.title;
  }

  String findAlbumTitleByIdSync(Id? id) {
    final album = findAlbumByIdSync(id);
    if (album == null) {
      return '';
    }
    return album.title;
  }
}
