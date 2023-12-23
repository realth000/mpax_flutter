import 'package:realm/realm.dart';

part '../generated/models/artwork_model.g.dart';

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
/// Not have an [ArtworkType] field because the same [_Artwork] may have
/// different [ArtworkType]s in different stored objects.
/// To directly store in Album and Music, use ArtworkWithType.
@RealmModel()
class _Artwork {
  /// Data hash.
  ///
  /// Use to specify artworks.
  @PrimaryKey()
  late final String dataHash;

  /// Format.
  late int format;

  late String filePath;
}
