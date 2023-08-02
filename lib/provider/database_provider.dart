import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/album_model.dart';
import 'package:mpax_flutter/models/artist_model.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

late final Isar _storage;
bool _initialized = false;

Future<void> initializeDatabase() async {
  if (_initialized) {
    return;
  }
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

@riverpod
class Database extends _$Database {
  @override
  Future<void> build() async {
    if (_initialized) {
      return;
    }
    await initializeDatabase();
  }

  /// Run a write transaction.
  Future<void> writeTxn(Future Function() callback) async {
    await _storage.writeTxn<void>(callback);
  }

  Future<void> savePlaylist(Playlist playlist) async {
    await _storage.writeTxn<void>(() async => _storage.playlists.put(playlist));
  }

  /// Save [Music] to database.
  Future<void> saveMusic(Music music) async {
    await _storage
        .writeTxn<void>(() async => _storage.musics.putByFilePath(music));
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

  Future<String> findArtistNamesByIdList(List<Id> idList) async {
    final artistList = idList
        .map((e) async => _storage.artists.where().idEqualTo(e).findFirst())
        .join(' - ');
    if (artistList.isEmpty) {
      return '';
    } else {
      return artistList;
    }
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

  /// Return a [Artwork].
  ///
  /// If exists an artwork with [Artwork.dataHash] equals to hashed [data],
  /// return it.
  /// Otherwise make a new [Artwork].
  Future<Artwork> fetchArtwork(ArtworkFormat format, String data) async {
    final storedArtwork = await _storage.artworks
        .where()
        .dataHashEqualTo(Artwork.calculateDataHash(data))
        .findFirst();
    if (storedArtwork != null) {
      return storedArtwork;
    }
    final artwork = Artwork(format: format, data: data);
    await _storage.writeTxn(() async => _storage.artworks.put(artwork));
    return artwork;
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
}
