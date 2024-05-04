import 'package:drift/drift.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/schema/schema.dart';

part 'image.g.dart';

/// DAO of [Image] table.
@DriftAccessor(tables: [Image])
class ImageDao extends DatabaseAccessor<AppDatabase> with _$ImageDaoMixin {
  /// Constructor.
  ImageDao(super.db);

  /// Select the unique [Image] which [Image.id] is [id].
  Future<ImageEntity?> selectImageById(int id) async {
    return (select(image)..where((x) => x.id.equals(id))).getSingleOrNull();
  }

  /// Select the unique [Image] which [Image.filePath] is [filePath].
  Future<ImageEntity?> selectImageByFilePath(String filePath) async {
    return (select(image)..where((x) => x.filePath.equals(filePath)))
        .getSingleOrNull();
  }

  /// Upsert and return the inserted [ImageEntity].
  Future<ImageEntity> upsertImageEx(ImageCompanion imageCompanion) async {
    return into(image)
        .insertReturning(imageCompanion, mode: InsertMode.insertOrReplace);
  }

  /// Delete the unique [Image] which [Image.id] is [id].
  Future<int> deleteImageById(int id) async {
    return (delete(image)..where((x) => x.id.equals(id))).go();
  }
}
