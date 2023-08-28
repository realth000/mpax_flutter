import 'dart:async';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

part '../generated/models/music_model.g.dart';

/// Model class for audio content.
///
/// Maintains audio info.
@Collection()
class Music {
  /// Default empty constructor.
  Music();

  /// Construct by file path.
  ///
  /// Only make [fileName] and [fileSize].
  Music.fromPath(this.filePath) {
    fileName = path.basename(filePath);
    fileSize = File(filePath).lengthSync();
  }

  /// Construct by file system entity.
  ///
  /// Including [fileSize].
  Music.fromEntry(FileSystemEntity file) {
    if (file.statSync().type != FileSystemEntityType.file) {
      return;
    }
    final f = File(file.path);
    filePath = f.path;
    fileName = path.basename(f.path);
    fileSize = f.lengthSync();
  }

  int? firstArtwork() {
    return artworkFrontCover ??
        artworkDisc ??
        artworkBackCover ??
        artworkArtist ??
        artworkIcon ??
        artworkUnknown;
  }

  Music makeGrowable() {
    return this..artistList = artistList.toList();
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  //////////////  File Properties //////////////

  /// File path of this audio.
  @Index(unique: true)
  String filePath = '';

  /// File name of this audio.
  String fileName = '';

  /// File size of this audio.
  int fileSize = -1;

  //////////////  Music metadata Properties //////////////

  /// Title name of this audio.
  String? title;

  /// Artist or singer of this audio.
  List<Id> artistList = <Id>[];

  /// Audio lyrics.
  String? lyrics;

  /// Front cover artwork id.
  int? artworkFrontCover;

  /// Back cover artwork id.
  int? artworkBackCover;

  /// Artist cover artwork id.
  int? artworkArtist;

  /// Disc cover artwork id.
  ///
  /// Most used.
  int? artworkDisc;

  /// Icon cover artwork id.
  int? artworkIcon;

  /// Artwork id at unknown position.
  ///
  /// Use as a default fallback image.
  int? artworkUnknown;

  //////////////  Album Properties //////////////

  /// [Album] [Id] of this audio.
  int? album;

  /// Track number in album of this audio.
  int? trackNumber = -1;

  /// Genre of the album.
  String? genre;

  /// Comment of this audio.
  String? comment;

  //////////////  Audio Properties //////////////

  /// Bit rate, for *.mp3, usually 128kbps/240kbps/320kbps.
  int? bitRate;

  /// Sample rate of this audio, usually 44100kHz/48000kHz.
  int? sampleRate;

  /// Channel numbers count, usually 2.
  int? channels;

  /// Audio duration in seconds..
  int? length;
}
