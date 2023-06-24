import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

part 'artwork_model.g.dart';

/// All cover image types.
///
/// In different positions.
enum ArtworkType {
  /// In front cover.
  frontCover,

  /// Back cover.
  backCover,

  /// Artist cover.
  artist,

  /// Album dic cover (most usually used).
  disc,

  /// Icon.
  icon,

  /// Unknown type.
  unknown,
}

/// Cover image supported formats.
enum ArtworkFormat {
  /// Jpeg and Jpg format.
  jpeg,

  /// Png format.
  png,

  /// Unknown format.
  unknown,
}

/// Cover image.
///
/// For Album, or Music.
/// Not have an [ArtworkType] field because the same [Artwork] may have
/// different [ArtworkType]s in different stored objects.
/// To directly store in Album and Music, use ArtworkWithType.
@Collection()
class Artwork {
  /// Constructor.
  Artwork({required this.format, required this.data}) {
    dataHash = calculateDataHash(data);
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Format.
  @Enumerated(EnumType.name)
  ArtworkFormat format;

  /// Data hash.
  ///
  /// Use to specify artworks.
  // FIXME: Seems unnecessary rebuild here.
  // Used to have 'final' modifier but has error so removed:
  // LateInitializationError: Field 'dataHash' has already been initialized.
  @Index(unique: true)
  late String dataHash;

  /// Data.
  String data;

  /// Calculate data hash.
  static String calculateDataHash(String data) =>
      md5.convert(utf8.encode(data)).toString();
}

// /// Typed Artwork.
// ///
// /// Use to save in [Album] and [Music].
// /// Works like a wrapper because the same [Artwork] may have different
// /// [ArtworkType]s in different stored objects.
// @Collection()
// class ArtworkWithType {
//   /// Constructor.
//   ArtworkWithType(this.type);
//
//   /// Save to database.
//   Future<void> save() async {
//     final storage = Get.find<DatabaseService>().storage;
//     await storage.writeTxn(() async {
//       await artwork.save();
//       await storage.artworkWithTypes.put(this);
//     });
//   }
//
//   /// Save to database synchronously.
//   void saveSync() {
//     final storage = Get.find<DatabaseService>().storage;
//     storage.writeTxnSync(() async {
//       await artwork.save();
//       await storage.artworkWithTypes.put(this);
//     });
//   }
//
//   /// Id in database.
//   Id id = Isar.autoIncrement;
//
//   /// Artwork type.
//   @Enumerated(EnumType.name)
//   ArtworkType type = ArtworkType.unknown;
//
//   /// Artwork.
//   IsarLink<Artwork> artwork = IsarLink<Artwork>();
// }
