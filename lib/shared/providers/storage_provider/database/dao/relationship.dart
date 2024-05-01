import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

part 'relationship.g.dart';

/// DAO of all relationship tables.
@DriftAccessor(
  tables: [
    Music,
    Album,
    Artist,
    Image,
    Playlist,
    MusicAlbumEntries,
    MusicArtistEntries,
    ArtistAlbumEntries,
    PlaylistMusicEntries,
    MusicImageEntries,
    AlbumImageEntries,
    PlaylistImageEntries,
  ],
)
final class RelationshipDao extends DatabaseAccessor<AppDatabase>
    with _$RelationshipDaoMixin {
  /// Constructor.
  RelationshipDao(super.db);

  /// Select an unique [Album] which owns music that [Music.id] is [id].
  Future<AlbumEntity?> selectAlbumByMusic(int id) async {
    return select(album)
        .join([
          innerJoin(
            musicAlbumEntries,
            musicAlbumEntries.music.equals(id),
          ),
        ])
        .map((x) => x.readTable(album))
        .getSingleOrNull();
  }

  /// Select all [Music]s that belongs to unique [Album] which owns [Music.id]
  /// is [id].
  Future<List<MusicEntity>> selectMusicByAlbum(int id) async {
    return select(music)
        .join([
          innerJoin(
            musicAlbumEntries,
            musicAlbumEntries.album.equals(id),
          ),
        ])
        .map((x) => x.readTable(music))
        .get();
  }

  /// Select an unique [Artist] who has the [Music.id] is [id].
  Future<List<ArtistEntity>> selectArtistByMusic(int id) async {
    return select(artist)
        .join([
          innerJoin(
            musicArtistEntries,
            musicArtistEntries.music.equals(id),
          ),
        ])
        .map((x) => x.readTable(artist))
        .get();
  }

  /// Select all [Music]s that belongs to the same [Artist] who owns [Music.id]
  /// is [id].
  Future<List<MusicEntity>> selectMusicByArtists(int id) async {
    return select(music)
        .join([
          innerJoin(
            musicArtistEntries,
            musicArtistEntries.artist.equals(id),
          ),
        ])
        .map((x) => x.readTable(music))
        .get();
  }

  /// Select all [Artist]s involve [Album.id] is [id].
  Future<List<ArtistEntity>> selectArtistByAlbum(int id) async {
    return select(artist)
        .join([
          innerJoin(
            artistAlbumEntries,
            artistAlbumEntries.album.equals(id),
          ),
        ])
        .map((x) => x.readTable(artist))
        .get();
  }

  /// Select all [Album]s has [Artist.id] is [id].
  Future<List<AlbumEntity>> selectAlbumByArtist(int id) async {
    return select(album)
        .join([
          innerJoin(
            artistAlbumEntries,
            artistAlbumEntries.artist.equals(id),
          ),
        ])
        .map((x) => x.readTable(album))
        .get();
  }

  // TODO: Playlist related operations.

  /// Select the unique [Image] used by [Music.id] is [id].
  Future<ImageEntity?> selectImageByMusic(int id) async {
    return select(image)
        .join([
          innerJoin(
            musicImageEntries,
            musicImageEntries.music.equals(id),
          ),
        ])
        .map((x) => x.readTable(image))
        .getSingleOrNull();
  }

  /// Upsert [MusicAlbumEntries].
  Future<int> upsertMusicAlbum({
    required int musicId,
    required int albumId,
  }) async {
    return into(musicAlbumEntries).insertOnConflictUpdate(
      MusicAlbumEntriesCompanion(
        music: Value(musicId),
        album: Value(albumId),
      ),
    );
  }

  /// Upsert [MusicArtistEntries].
  Future<int> upsertMusicArtist({
    required int musicId,
    required int artistId,
  }) async {
    return into(musicArtistEntries).insertOnConflictUpdate(
      MusicArtistEntriesCompanion(
        music: Value(musicId),
        artist: Value(artistId),
      ),
    );
  }

  /// Upsert [ArtistAlbumEntries].
  Future<int> upsertArtistAlbum({
    required int artistId,
    required int albumId,
  }) async {
    return into(artistAlbumEntries).insertOnConflictUpdate(
      ArtistAlbumEntriesCompanion(
        artist: Value(artistId),
        album: Value(albumId),
      ),
    );
  }
}
