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

/// Wrapper class for a [Set] of artist id-name pair.
final class ArtistDbInfoSet extends IntStringPairSet {
  /// Constructor.
  ArtistDbInfoSet(super.values);
}

/// Wrapper class for a [Set] of artist id-name pair.
final class ImageDbInfoSet extends IntSet {
  /// Constructor.
  ImageDbInfoSet(super.values);
}
