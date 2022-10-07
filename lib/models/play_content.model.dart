import 'dart:io';

import 'package:path/path.dart' as path;

/// Model class for audio content.
///
/// Maintains audio info.
class PlayContent {
  /// Default empty constructor.
  PlayContent();

  /// Construct by file path.
  ///
  /// Only make [contentName] and [contentSize].
  PlayContent.fromPath(this.contentPath) {
    contentName = path.basename(contentPath);
    contentSize = File(contentPath).lengthSync();
  }

  /// Construct by file system entity.
  ///
  /// Including [contentSize].
  PlayContent.fromEntry(FileSystemEntity file) {
    if (file.statSync().type != FileSystemEntityType.file) {
      return;
    }
    final f = File(file.path);
    contentPath = f.path;
    contentName = path.basename(f.path);
    contentSize = f.lengthSync();
  }

  /// Construct directly from data.
  ///
  /// All data types are needed.
  PlayContent.fromData(
    this.contentPath,
    this.contentName,
    this.contentSize,
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

  /// File path of this audio.
  String contentPath = '';

  /// File name of this audio.
  String contentName = '';

  /// File size of this audio.
  int contentSize = -1;

  /// Artist or singer of this audio.
  String artist = '';

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

  /// Id in the database table, not used away from database.
  static int id = -1;

  /// Convert to map, sqflite3 need this format.
  Map<String, dynamic> toMap() {
    id++;
    return {
      'id': id,
      'path': contentPath,
      'name': contentName,
      'size': contentSize,
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
    };
  }
}
