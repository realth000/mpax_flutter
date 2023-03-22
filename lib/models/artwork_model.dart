import 'package:isar/isar.dart';

/// All cover image types.
///
/// In different positions.
enum ArtworkType {
  /// In front cover.
  frontCover,

  /// Back cover
  backCover,

  /// Artist cover
  artist,

  /// Album dic cover (most usually used).
  disc,

  /// Icon
  icon,
}

/// Cover image supported formats.
enum ArtworkFormat {
  /// Jpeg and Jpg format.
  jpeg,

  /// Png format.
  png,
}

/// Cover image.
///
/// For [Album], or [Music].
@Collection()
class Artwork {
  /// Constructor.
  Artwork({required this.format, required this.data});

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Format.
  final ArtworkFormat format;

  /// Data.
  final String data;
}
