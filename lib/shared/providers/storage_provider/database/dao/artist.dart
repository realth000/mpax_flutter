import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

part 'artist.g.dart';

/// DAO of table [Artist].
@DriftAccessor(tables: [Artist])
final class ArtistDao extends DatabaseAccessor<AppDatabase>
    with _$ArtistDaoMixin {
  /// Constructor.
  ArtistDao(super.db);

  /// Select unique [Artist] which [Artist.name] is [name].
  ///
  /// Return null if no record matches.
  Future<ArtistEntity?> selectArtistByName(String name) async {
    return (select(artist)..where((x) => x.name.equals(name)))
        .getSingleOrNull();
  }

  /// Insert.
  Future<int> insertArtist(ArtistCompanion artistCompanion) async {
    return into(artist).insert(artistCompanion);
  }

  /// Update.
  ///
  /// Return the inserted entity.
  Future<ArtistEntity> insertArtistEx(ArtistCompanion artistCompanion) async {
    return into(artist).insertReturning(artistCompanion);
  }

  /// Update.
  ///
  /// Write [artistEntity], all absent fields will not change.
  Future<int> updateArtistIgnoreAbsent(
    ArtistEntity artistEntity,
  ) async {
    return (update(artist)..where((e) => e.id.equals(artistEntity.id)))
        .write(artistEntity);
  }

  /// Update.
  ///
  /// Replace with [artistEntity], save all absent fields.
  Future<bool> replaceArtist(ArtistEntity artistEntity) async {
    return update(artist).replace(artistEntity);
  }

  /// Upsert and return the inserted [ArtistEntity].
  Future<ArtistEntity> upsertArtistEx(ArtistCompanion artistCompanion) async {
    return into(artist)
        .insertReturning(artistCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Delete unique [Artist] which [Artist.name] is [name].
  Future<int> deleteArtistByName(String name) async {
    return (delete(artist)..where((x) => x.name.equals(name))).go();
  }
}
