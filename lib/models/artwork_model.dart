import 'dart:typed_data';

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
  /// [skipHash] indicates that this [Artwork] only use in memory and not store
  /// to database.
  /// Till now only use in not scaled album artwork.
  ///
  /// Unfortunately, [data] here should be a *required* argument but if we do
  /// so isar reports 'Constructor parameter does not match a property' error
  /// when generating code. And Uint8List is not supported by isar so the only
  /// way to pass compile is make [data] an "optional argument" which make cause
  /// weird behavior when forgot to add data.
  Artwork(this.format, this.filePath,
      {Uint8List? data, bool skipHash = false}) {
    if (skipHash) {
      dataHash = '';
    } else {
      // if (data == null) {
      //   throw Exception(
      //       'Please use not null or empty "data" here, when constructing artwork $filePath');
      // }
      dataHash = calculateDataHash(data ?? Uint8List(0));
    }
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

  String filePath;

  /// Calculate data hash.
  static String calculateDataHash(Uint8List data) =>
      md5.convert(data).toString();
}
