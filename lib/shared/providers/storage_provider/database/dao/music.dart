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

  /// Select all [Music]s those [Music.title] is [title].
  Future<List<MusicEntity>> selectMusicByTitle(String title) async {
    return (select(music)..where((x) => x.title.equals(title))).get();
  }

  /// Select all [Music]s those [Music.sourceDir] is [sourceDir].
  Future<List<MusicEntity>> selectMusicBySourceDir(String sourceDir) async {
    return (select(music)..where((x) => x.sourceDir.equals(sourceDir))).get();
  }

  /// Upsert.
  Future<int> upsertMusic(MusicCompanion musicCompanion) async {
    return into(music).insertOnConflictUpdate(musicCompanion);
  }

  /// Delete the unique [Music] which [Music.filePath] is [filePath].
  Future<int> deleteMusicByFilePath(String filePath) async {
    return (delete(music)..where((x) => x.filePath.equals(filePath))).go();
  }

  /// Delete all [Music]s those [Music.title] is [title].
  Future<int> deleteMusicByTitle(String title) async {
    return (delete(music)..where((x) => x.title.equals(title))).go();
  }
}
