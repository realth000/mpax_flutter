import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/shared_model.dart';

part 'album.g.dart';

/// DAO of [Album] table.
@DriftAccessor(tables: [Album])
final class AlbumDao extends DatabaseAccessor<AppDatabase>
    with _$AlbumDaoMixin {
  /// Constructor.
  AlbumDao(super.db);

  /// Select the unique [Album] by it's [id].
  Future<AlbumEntity?> selectAlbumById(int id) async {
    return (select(album)..where((x) => x.id.equals(id))).getSingleOrNull();
  }

  /// Select all [Album]s those [Album.title] is [title].
  ///
  /// Return an empty list when no record matches.
  Future<List<AlbumEntity>> selectAlbumByTitle(String title) async {
    return (select(album)..where((x) => x.title.equals(title))).get();
  }

  /// Select the single [Album] which:
  ///
  /// * [Album.title] is [title].
  /// * [Album.artist] is a string serialized from `StringSet`.
  ///
  /// Return null is no record matches.
  Future<AlbumEntity?> selectAlbumByTitleAndArtist({
    required String title,
    required StringSet artistListString,
  }) async {
    return (select(album)
          ..where(
            (e) =>
                e.title.equals(title) &
                e.artist.equals(StringSet.converter.toSql(artistListString)),
          ))
        .getSingleOrNull();
  }

  /// Insert.
  Future<int> insertAlbum(AlbumCompanion albumCompanion) async {
    return into(album).insert(albumCompanion);
  }

  /// Insert.
  ///
  /// Return the inserted entity.
  Future<AlbumEntity> insertAlbumEx(AlbumCompanion albumCompanion) async {
    return into(album).insertReturning(albumCompanion);
  }

  /// Update.
  ///
  /// Write [albumEntity], all absent fields will not change.
  Future<int> updateAlbumIgnoreAbsent(AlbumEntity albumEntity) async {
    return (update(album)..where((e) => e.id.equals(albumEntity.id)))
        .write(albumEntity);
  }

  /// Update.
  ///
  /// Replace with [albumEntity], write all absents fields.
  Future<bool> replaceAlbum(AlbumEntity albumEntity) async {
    return update(album).replace(albumEntity);
  }

  /// Upsert and return the inserted [AlbumEntity].
  Future<AlbumEntity> upsertAlbumEx(AlbumCompanion albumCompanion) async {
    return into(album)
        .insertReturning(albumCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Delete.
  Future<int> deleteAlbum(AlbumCompanion albumCompanion) async {
    return (delete(album)..where((x) => x.id.equals(albumCompanion.id.value)))
        .go();
  }

  /// Delete all [Album]s those [Album.title] is [title].
  ///
  /// This may delete more than one [Album] records as `title` together with
  /// `artist` is the unique key in table.
  Future<int> deleteAlbumByTitle(String title) async {
    return (delete(album)..where((x) => x.title.equals(title))).go();
  }

  /// Delete the unique [Album] which:
  ///
  /// * [Album.title] is [title].
  /// * [Album.artist] is [artist].
  Future<int> deleteAlbumByTitleAndArtist(String title, String artist) async {
    return (delete(album)
          ..where((x) => x.title.equals(title) & x.artist.equals(artist)))
        .go();
  }
}
