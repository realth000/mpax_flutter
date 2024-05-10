import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

part 'music.g.dart';

/// DAO of table [Music].
@DriftAccessor(tables: [Music])
final class MusicDao extends DatabaseAccessor<AppDatabase>
    with _$MusicDaoMixin {
  /// Constructor.
  MusicDao(super.db);

  /// Select the unique [Music] which [Music.filePath] is [filePath].
  ///
  /// Return null if no record matches.
  Future<MusicEntity?> selectMusicByFilePath(String filePath) async {
    return (select(music)..where((x) => x.filePath.equals(filePath)))
        .getSingleOrNull();
  }

  /// Select by id.
  Future<MusicEntity?> selectMusicById(int id) async {
    return (select(music)..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  /// Select all music in [Music] table.
  Future<List<MusicEntity>> selectAll() async {
    return select(music).get();
  }

  /// Select all [Music]s those [Music.title] is [title].
  Future<List<MusicEntity>> selectMusicByTitle(String title) async {
    return (select(music)..where((x) => x.title.equals(title))).get();
  }

  /// Select all [Music]s those [Music.sourceDir] is [sourceDir].
  Future<List<MusicEntity>> selectMusicBySourceDir(String sourceDir) async {
    return (select(music)..where((x) => x.sourceDir.equals(sourceDir))).get();
  }

  /// Insert.
  Future<int> insertMusic(MusicCompanion musicCompanion) async {
    return into(music).insert(musicCompanion);
  }

  /// Insert.
  ///
  /// Return the inserted [MusicEntity].
  Future<MusicEntity> insertMusicEx(MusicCompanion musicCompanion) async {
    return into(music).insertReturning(musicCompanion);
  }

  /// Update.
  ///
  /// Write [musicEntity] absent fields will not be changed.
  Future<int> updateMusicIgnoreAbsent(MusicEntity musicEntity) async {
    return (update(music)..where((e) => e.id.equals(musicEntity.id)))
        .write(musicEntity);
  }

  /// Update.
  ///
  /// Write [musicCompanion], absent fields will not be changed.
  Future<MusicEntity> updateMusicIgnoreAbsentEx(
    int id,
    MusicCompanion musicCompanion,
  ) async {
    return (await (update(music)..where((e) => e.id.equals(id)))
            .writeReturning(musicCompanion))
        .first;
  }

  /// Update.
  ///
  /// Replace [musicEntity], save all absents fields.
  ///
  /// This is truly used for updating an exist record.
  Future<bool> replaceMusic(MusicEntity musicEntity) async {
    return update(music).replace(musicEntity);
  }

  /// Update.
  ///
  /// Replace record given [musicCompanion].
  Future<bool> replaceMusicById(MusicCompanion musicCompanion) async {
    return update(music).replace(musicCompanion);
  }

  /// Upsert.
  Future<int> upsertMusic(MusicCompanion musicCompanion) async {
    return into(music).insert(musicCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Upsert and return the inserted model.
  Future<MusicEntity> upsertMusicEx(MusicCompanion musicCompanion) async {
    return into(music)
        .insertReturning(musicCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Delete the unique [Music] which [Music.filePath] is [filePath].
  Future<int> deleteMusicByFilePath(String filePath) async {
    return (delete(music)..where((x) => x.filePath.equals(filePath))).go();
  }

  /// Delete all [Music]s those [Music.title] is [title].
  Future<int> deleteMusicByTitle(String title) async {
    return (delete(music)..where((x) => x.title.equals(title))).go();
  }

  /// Delete.
  Future<int> deleteMusicById(int id) async {
    return (delete(music)..where((e) => e.id.equals(id))).go();
  }
}
