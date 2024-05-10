import 'package:mpax_flutter/shared/providers/storage_provider/database/shared_model.dart';

/// Wrapper class for music id-name pair.
final class MusicDbInfo extends IntStringPair {
  /// Constructor.
  MusicDbInfo(super.intValue, super.stringValue);

  /// Music id.
  int get id => super.intValue;

  /// Music title.
  String get name => super.stringValue;
}

/// Wrapper class for a [Set] of music id-name pair.
final class MusicDbInfoSet extends IntStringPairSet {
  /// Constructor.
  MusicDbInfoSet(super.values);
}

/// Wrapper class for album id-name pair.
final class AlbumDbInfo extends IntStringPair {
  /// Constructor.
  AlbumDbInfo(super.intValue, super.stringValue);

  /// Album id.
  int get id => super.intValue;

  /// Album title.
  String get name => super.stringValue;

  /// Nullable constructor.
  static AlbumDbInfo? fromValue(IntStringPair? intStringPair) =>
      intStringPair != null
          ? AlbumDbInfo(intStringPair.intValue, intStringPair.stringValue)
          : null;
}

/// Wrapper class for a [Set] of album id-title pair.
final class AlbumDbInfoSet extends IntStringPairSet {
  /// Constructor.
  AlbumDbInfoSet(super.values);

  /// Nullable constructor.
  static AlbumDbInfoSet? fromValue(IntStringPairSet? intStringPairSet) =>
      intStringPairSet != null ? AlbumDbInfoSet(intStringPairSet.values) : null;
}

/// Wrapper class for artist id-name pair.
final class ArtistDbInfo extends IntStringPair {
  /// Constructor.
  ArtistDbInfo(super.intValue, super.stringValue);

  /// Artist id.
  int get id => super.intValue;

  /// Artist  name.
  String get name => super.stringValue;
}

/// Wrapper class for a [Set] of artist name
final class ArtistDbInfoSet extends StringSet {
  /// Constructor.
  ArtistDbInfoSet(super.values);

  /// Nullable constructor.
  static ArtistDbInfoSet? fromValue(StringSet? intStringPairSet) =>
      intStringPairSet != null
          ? ArtistDbInfoSet(intStringPairSet.values)
          : null;
}

/// Wrapper class for image id-filePath pair.
final class ImageDbInfo extends IntStringPair {
  /// Constructor.
  ImageDbInfo(super.intValue, super.stringValue);
}

/// Wrapper class for a [Set] of image id-filePath pair.
final class ImageDbInfoSet extends IntStringPairSet {
  /// Constructor.
  ImageDbInfoSet(super.values);

  /// Nullable constructor.
  static ImageDbInfoSet? fromValue(IntStringPairSet? intStringPairSet) =>
      intStringPairSet != null ? ImageDbInfoSet(intStringPairSet.values) : null;
}
