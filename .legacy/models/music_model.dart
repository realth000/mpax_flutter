import 'package:realm/realm.dart';

part '../generated/models/music_model.g.dart';

/// Model class for audio content.
///
/// Maintains audio info.
@RealmModel()
class _Music {
  //////////////  File Properties //////////////

  /// File path of this audio.
  @PrimaryKey()
  late final String filePath;

  /// File name of this audio.
  late String fileName;

  /// File size of this audio.
  late int fileSize;

  //////////////  Music metadata Properties //////////////

  /// Title name of this audio.
  late String? title;

  /// Artist or singer id of this audio.
  late List<int> artistIdList;

  /// Audio lyrics.
  late String? lyrics;

  /// Front cover artwork id.
  late int? artworkFrontCoverId;

  /// Back cover artwork id.
  late int? artworkBackCoverId;

  /// Artist cover artwork id.
  late int? artworkArtistId;

  /// Disc cover artwork id.
  ///
  /// Most used.
  late int? artworkDiscId;

  /// Icon cover artwork id.
  late int? artworkIconId;

  /// Artwork id at unknown position.
  ///
  /// Use as a default fallback image.
  late int? artworkUnknownId;

  //////////////  Album Properties //////////////

  /// Album id of this audio.
  late int? albumId;

  /// Track number in album of this audio.
  late int? trackNumberId;

  /// Genre of the album.
  late String? genre;

  /// Comment of this audio.
  late String? comment;

  //////////////  Audio Properties //////////////

  /// Bit rate, for *.mp3, usually 128kbps/240kbps/320kbps.
  late int? bitRate;

  /// Sample rate of this audio, usually 44100kHz/48000kHz.
  late int? sampleRate;

  /// Channel numbers count, usually 2.
  late int? channels;

  /// Audio duration in seconds..
  late int? length;
}
