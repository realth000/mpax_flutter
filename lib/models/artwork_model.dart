import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

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
/// For [Album], or [Music].
@Collection()
class Artwork {
  /// Constructor.
  Artwork({required this.format, required this.data}) {
    dataHash = md5.convert(utf8.encode(data)).toString();
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Format.
  final ArtworkFormat format;

  /// Data hash.
  ///
  /// Use to specify artworks.
  @Index(unique: true)
  late final String dataHash;

  /// Data.
  final String data;
}
