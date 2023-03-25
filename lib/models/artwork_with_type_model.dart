import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../services/database_service.dart';
import 'artwork_model.dart';

part 'artwork_with_type_model.g.dart';

/// Typed Artwork.
///
/// Use to save in [Album] and [Music].
/// Works like a wrapper because the same [Artwork] may have different
/// [ArtworkType]s in different stored objects.
@Collection()
class ArtworkWithType {
  /// Constructor.
  ArtworkWithType(this.type);

  /// Save to database.
  Future<void> save() async {
    final storage = Get.find<DatabaseService>().storage;
    await storage.writeTxn(() async {
      await artwork.save();
      await storage.artworkWithTypes.put(this);
    });
  }

  /// Save to database synchronously.
  void saveSync() {
    final storage = Get.find<DatabaseService>().storage;
    storage.writeTxnSync(() async {
      await artwork.save();
      await storage.artworkWithTypes.put(this);
    });
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Artwork type.
  @Enumerated(EnumType.name)
  ArtworkType type = ArtworkType.unknown;

  /// Artwork.
  IsarLink<Artwork> artwork = IsarLink<Artwork>();
}
