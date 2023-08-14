import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/album_model.dart';
import 'package:mpax_flutter/models/artist_model.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/provider/scanner_provider.dart';
import 'package:mpax_flutter/utils/compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

late final Isar _storage;
bool _initialized = false;

Future<void> initializeDatabase() async {
  if (_initialized) {
    return;
  }
  _initialized = true;
  final databaseDirectory = await getApplicationSupportDirectory();
  if (!databaseDirectory.existsSync()) {
    await databaseDirectory.create();
  }
  _storage = await Isar.open(
    [
      AlbumSchema,
      ArtistSchema,
      ArtworkSchema,
      MusicSchema,
      PlaylistSchema,
    ],
    name: 'mpax',
    directory: databaseDirectory.path,
  );
  // Check where library playlist exists.
  // If not, create one.
  final libraryPlaylist = await _storage.playlists
      .where()
      .nameEqualTo(libraryPlaylistName)
      .findFirst();
  if (libraryPlaylist == null) {
    await _storage.writeTxn<void>(
      () async =>
          _storage.playlists.put(Playlist()..name = libraryPlaylistName),
    );
  }
}

class Database {
  Database(this.ref);

  Ref ref;

  Future<List<Playlist>> allPlaylist() async {
    // Remove media library playlist which has id 1 at index 0.
    return (await _storage.playlists.where().findAll())..removeAt(0);
  }

  /// Run a write transaction.
  Future<void> writeTxn(Future Function() callback) async {
    await _storage.writeTxn<void>(callback);
  }

  Future<void> savePlaylist(Playlist playlist) async {
    await _storage.writeTxn<void>(() async => _storage.playlists.put(playlist));
  }

  // TODO: Better performance.
  /// Save [Music] to database.
  Future<void> saveMusic(Music music) async {
    await _storage.writeTxn<void>(() async {
      await _storage.musics.putByFilePath(music);
      final library = (await _storage.playlists.get(1))!.makeGrowable();
      await library.addMusic(music);
      await _storage.playlists.put(library);
    });
  }

  /// Save [Artist] to database.
  Future<void> saveArtist(Artist artist) async {
    await _storage
        .writeTxn<void>(() async => _storage.artists.putByName(artist));
  }

  Future<void> saveAlbum(Album album) async {
    await _storage.writeTxn<void>(() async => _storage.albums.put(album));
  }

  /// Save [Artwork] to database.
  Future<void> saveArtwork(Artwork artwork) async {
    await _storage
        .writeTxn<void>(() async => _storage.artworks.putByDataHash(artwork));
  }

  Future<Playlist?> findPlaylistById(Id? id) async {
    if (id == null) {
      return null;
    }
    return (await _storage.playlists.get(id))?.makeGrowable();
  }

  Future<Playlist?> findPlaylistByName(String name) async {
    return (await _storage.playlists.where().nameEqualTo(name).findFirst())
        ?.makeGrowable();
  }

  Playlist? findPlaylistByNameSync(String name) {
    return _storage.playlists
        .where()
        .nameEqualTo(name)
        .findFirstSync()
        ?.makeGrowable();
  }

  Future<Music?> findMusicById(Id? id) async {
    if (id == null) {
      return null;
    }
    return (await _storage.musics.where().idEqualTo(id).findFirst())
        ?.makeGrowable();
  }

  Future<Music?> findMusicByFilePath(String filePath) async {
    return (await _storage.musics.where().filePathEqualTo(filePath).findFirst())
        ?.makeGrowable();
  }

  Music? findMusicByFilePathSync(String filePath) {
    return _storage.musics
        .where()
        .filePathEqualTo(filePath)
        .findFirstSync()
        ?.makeGrowable();
  }

  Future<String> findArtistNamesByIdList(List<Id> idList) async {
    final artistList = <String>[];
    for (final id in idList) {
      final artist = await _storage.artists.get(id);
      if (artist == null) {
        continue;
      }
      artistList.add(artist.name);
    }
    return artistList.join(' - ');
  }

  String findArtistNamesByIdListSync(List<Id> idList) {
    final artistList = idList
        .map((e) => _storage.artists.where().idEqualTo(e).findFirstSync())
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
    return (await _storage.albums.where().idEqualTo(id).findFirst())
        ?.makeGrowable();
  }

  Future<String> findAlbumTitleById(Id? id) async {
    final album = await findAlbumById(id);
    if (album == null) {
      return '';
    }
    return album.title;
  }

  Future<Artwork?> findArtworkById(Id? id) async {
    if (id == null) {
      return null;
    }
    return _storage.artworks.get(id);
  }

  Artwork? findArtworkByIdSync(Id? id) {
    if (id == null) {
      return null;
    }
    if (id < 0) {
      return null;
    }
    return _storage.artworks.getSync(id);
  }

  //////////////// fetch ////////////////

  /// Return a [Music].
  ///
  /// If exists a music with [filePath], return it.
  /// Otherwise make a new [Music].
  Future<Music> fetchMusic(
    String filePath, {
    Metadata? metadata,
  }) async {
    final storedMusic =
        await _storage.musics.where().filePathEqualTo(filePath).findFirst();
    if (storedMusic != null) {
      return storedMusic.makeGrowable();
    }
    final music = Music.fromPath(filePath);
    await _storage.writeTxn(() async => _storage.musics.put(music));
    await music.refreshMetadata(metadata: metadata);
    return music;
  }

  /// Return a [Artist].
  ///
  /// If exists an artist with [name], return it.
  /// Otherwise make a new [Artist].
  Future<Artist> fetchArtist(
    String name,
  ) async {
    final storedArtist =
        await _storage.artists.where().nameEqualTo(name).findFirst();
    if (storedArtist != null) {
      return storedArtist.makeGrowable();
    }
    final artist = Artist(name: name);
    await _storage.writeTxn(() async => _storage.artists.put(artist));
    return artist;
  }

  /// Return a [Album].
  ///
  /// If exists an album with [title] and [artists], return it.
  /// Otherwise make a new [Album].
  Future<Album> fetchAlbum(
    String title,
    List<Id> artists, {
    String? albumTitle,
    int? albumTrackCount,
    int? artworkId,
    int? albumYear,
  }) async {
    final storedAlbum =
        await _storage.albums.where().titleEqualTo(title).findFirst();
    if (storedAlbum != null) {
      return storedAlbum.makeGrowable();
    }
    final album = Album(title: title, artistIds: artists)
      ..title = albumTitle ?? ''
      ..trackCount = albumTrackCount
      ..year = albumYear
      ..artwork = artworkId;
    await _storage.writeTxn(() async => _storage.albums.put(album));
    return album;
  }

  /// Return a [Artwork] with original [data].
  ///
  /// Because image data saved in cache are compressed, use this function to
  /// find that cached file with original image data came from metadata.
  /// Without this function, it's impossible to know whether the original
  /// metadata is already cached or not.
  ///
  /// Because compressing image data is much slower than calculating hash, use
  /// this original hash to reduce image compression.
  /// Though the image library works well on mobile platforms, there CPU is
  /// worse than desktop's, while desktop platforms only have slow compressing
  /// algorithm.
  ///
  /// If [scaleImage] is ture, calculate hash from original image data, save
  /// that hash and to database, then compress image and save to cache file.
  ///
  /// If [scaleImage] is false, means this is the only not scaled image to show
  /// in ui specially, for example in the music page where needs a large image.
  /// Only save to a certain cache file for later reading, will not save to
  /// database.
  ///
  Future<Artwork> fetchArtwork(
    ArtworkFormat format,
    Uint8List data, {
    bool scaleImage = true,
  }) async {
    if (scaleImage) {
      // Scaled images are saved in cache and also hash in database.
      final hash = md5.convert(data).toString();
      final storedArtwork =
          await _storage.artworks.where().dataHashEqualTo(hash).findFirst();
      if (storedArtwork != null) {
        return storedArtwork;
      }
      // Save thumb image to temporary directory.
      final coverFile = File(
        '${(await getApplicationSupportDirectory()).path}/cover_cache_${DateTime.now().microsecondsSinceEpoch}',
      );
      final compressedImage = await compressImage(data);
      await coverFile.writeAsBytes(compressedImage);
      final artwork = Artwork(
        format,
        coverFile.path,
        data: compressedImage,
        hash: hash,
      );
      await _storage.writeTxn(() async => _storage.artworks.put(artwork));
      return artwork;
    } else {
      final coverFile = File(
        '${(await getTemporaryDirectory()).path}/cover_${DateTime.now().microsecondsSinceEpoch}',
      );
      await coverFile.writeAsBytes(data);
      return Artwork(format, coverFile.path, data: data, skipHash: true);
    }
  }

  Future<Artwork?> fetchArtworkById(int? id) async {
    if (id == null) {
      return null;
    }
    return _storage.artworks.get(id);
  }

  Future<Uint8List?> fetchArtworkDataById(int? id) async {
    if (id == null) {
      return null;
    }
    final artwork = await _storage.artworks.get(id);
    if (artwork == null) {
      return null;
    }
    final file = File(artwork.filePath);
    return file.readAsBytes();
  }

  /// Return a list of [Playlist]. Returning a list because playlist allowed to
  /// have same name.
  ///
  /// Return all playlist has the given [playlistName].
  /// If not exists, return a new one.
  Future<List<Playlist>> fetchPlaylist(
    String playlistName,
  ) async {
    final storedPlaylistList =
        await _storage.playlists.where().nameEqualTo(playlistName).findAll();
    if (storedPlaylistList.isNotEmpty) {
      for (var element in storedPlaylistList) {
        element = element.makeGrowable();
      }
      return storedPlaylistList;
    }
    final playlist = Playlist()..name = playlistName;
    await _storage.writeTxn(() async => _storage.playlists.put(playlist));
    return [playlist];
  }

  Future<Playlist?> fetchPlaylistById(int? id) async {
    if (id == null) {
      return null;
    }
    return _storage.playlists.get(id);
  }

  Future<Artwork?> reloadArtwork(
    String musicFilePath,
    int id, {
    bool scaleImage = true,
  }) async {
    final metadata =
        await ref.read(scannerProvider.notifier).fetchMetadata(musicFilePath);

    if (metadata == null) {
      return null;
    }
    final artworkData = metadata.firstImage();
    if (artworkData == null) {
      return null;
    }

    if (scaleImage) {
      // When reloading a scaled image, it's a thumb image, cached with timestamp.
      // Need to load the exact save path from database.
      final artwork = await _storage.artworks.get(id);
      if (artwork == null) {
        return null;
      }
      final filePath = artwork.filePath;
      final hash = md5.convert(artworkData).toString();
      final compressedData = await compressImage(artworkData);
      // Save thumb image to temporary directory.
      final coverFile = File(filePath);
      await coverFile.writeAsBytes(compressedData);
      final refreshedArtwork = Artwork(
        artwork.format,
        coverFile.path,
        data: compressedData,
        hash: hash,
      );
      await _storage
          .writeTxn(() async => _storage.artworks.put(refreshedArtwork));
      return refreshedArtwork;
    } else {
      // When it's not a scaled image, it's the only one full cover to show.
      // That artwork not stored in database, only used once.
      // Save path without timestamp.
      final coverFile = File(
        '${(await getApplicationSupportDirectory()).path}/cover_${DateTime.now().microsecondsSinceEpoch}',
      );
      await coverFile.writeAsBytes(artworkData);
      // Till now the format here is not used, so set with [Artwork.unknown].
      return Artwork(ArtworkFormat.unknown, coverFile.path, data: artworkData);
    }
  }
}

@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) => Database(ref);
