import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as path;

import 'artist_model.dart';

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

  /// Construct directly from data.
  ///
  /// All data types are needed.
  Music.fromData(
    this.filePath,
    this.fileName,
    this.fileSize,
    this.artist,
    this.title,
    this.trackNumber,
    this.bitRate,
    this.albumArtist,
    this.albumTitle,
    this.albumYear,
    this.albumTrackCount,
    this.genre,
    this.comment,
    this.sampleRate,
    this.channels,
    this.length,
    this.albumCover,
  );

  /// Id in database.
  Id? id = Isar.autoIncrement;

  /// File path of this audio.
  @Index(unique: true, caseSensitive: true)
  final String filePath;

  /// File name of this audio.
  String fileName = '';

  /// File size of this audio.
  int fileSize = -1;

  /// Artist or singer of this audio.
  Artist artist;

  /// Title name of this audio.
  String title = '';

  /// Track number in album of this audio.
  int trackNumber = -1;

  /// Bit rate, for *.mp3, usually 128kbps/240kbps/320kbps.
  int bitRate = -1;

  /// Artists of the album, may be more than one artist.
  String albumArtist = '';

  /// Name of the album.
  String albumTitle = '';

  /// Album cover image, base64 encoded data.
  String albumCover = '';

  /// Album publish year.
  int albumYear = -1;

  /// Album total track counts.
  int albumTrackCount = -1;

  /// Genre of the album.
  String genre = '';

  /// Comment of this audio.
  String comment = '';

  /// Sample rate of this audio, usually 44100kHz/48000kHz.
  int sampleRate = -1;

  /// Channel numbers count, usually 2.
  int channels = -1;

  /// Audio duration in seconds..
  int length = -1;

  /// Audio lyrics.
  String lyrics = '';

  /// Convert to map, sqflite3 need this format.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': filePath,
      'name': fileName,
      'size': fileSize,
      'title': title,
      'artist': artist,
      'album_title': albumTitle,
      'album_artist': albumArtist,
      'album_year': albumYear,
      'album_track_count': albumTrackCount,
      'track_number': trackNumber,
      'bit_rate': bitRate,
      'sample_rate': sampleRate,
      'genre': genre,
      'comment': comment,
      'channels': channels,
      'length': length,
      'album_cover': albumCover,
      'lyrics': lyrics,
    };
  }
}
