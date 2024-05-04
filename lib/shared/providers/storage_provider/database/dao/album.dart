import 'package:drift/drift.dart';
import 'package:drift/extensions/json1.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

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
  /// * [Album.artist] is [artist].
  ///
  /// Return null is no record matches.
  Future<AlbumEntity?> selectAlbumByTitleAndArtist({
    required String title,
    required List<String> artist,
  }) async {
    return (select(album)
          ..where(
            (x) =>
                x.title.equals(title) &
                x.artist
                    .jsonEach(this, r'#$.values.stringValue')
                    .value
                    .cast<String>()
                    .isIn(artist),
          ))
        .getSingleOrNull();
  }

  /// Upsert.
  Future<AlbumEntity> upsertAlbum(AlbumCompanion albumCompanion) async {
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
