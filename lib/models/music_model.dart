import 'dart:io';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

import '../services/metadata_service.dart';
import 'album_model.dart';
import 'artist_model.dart';
import 'artwork_model.dart';

/// Model class for audio content.
///
/// Maintains audio info.
@Collection()
class Music {
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

  /// Construct directly from data.
  ///
  /// All data types are needed.
  Music.fromData(
    this.filePath,
    this.fileName,
    this.fileSize,
    Artist artist,
    this.title,
    this.trackNumber,
    this.bitRate,
    this.genre,
    this.comment,
    this.sampleRate,
    this.channels,
    this.length,
  ) {
    isar.artist.put(artist);
  }

  /// Read metadata from file.
  Future<bool> refreshMetadata({
    String? filePath,
    bool loadImage = false,
    bool scaleImage = true,
    bool fast = true,
  }) async {
    if (filePath != null) {
      this.filePath = filePath;
      fileName = path.basename(filePath);
      fileSize = File(this.filePath).lengthSync();
    }
    final metadata =
        await Get.find<MetadataService>().readMetadata(this.filePath);
    if (metadata == null) {
      return false;
    }
    title = metadata.title ?? fileName;
    return true;
  }

  /// Id in database.
  Id? id = Isar.autoIncrement;

  //////////////  File Properties //////////////

  /// File path of this audio.
  @Index(unique: true, caseSensitive: true)
  late final String filePath;

  /// File name of this audio.
  String fileName = '';

  /// File size of this audio.
  int fileSize = -1;

  //////////////  Music metadata Properties //////////////

  /// Title name of this audio.
  String? title;

  /// Artist or singer of this audio.
  final artist = IsarLink<Artist>();

  /// Audio lyrics.
  String? lyrics;

  /// All artworks.
  final artworkMap = <ArtworkType, IsarLink<Artwork>>{};

  //////////////  Album Properties //////////////

  /// Album of this audio.
  final album = IsarLink<Album>();

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
