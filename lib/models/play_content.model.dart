import 'dart:io';

import 'package:get/get.dart';
import 'package:mpax_flutter/services/metadata_service.dart';
import 'package:path/path.dart' as path;

class PlayContent {
  PlayContent();

  PlayContent.fromEntry(FileSystemEntity file) {
    if (file.statSync().type != FileSystemEntityType.file) {
      return;
    }
    final f = File(file.path);
    contentPath = f.path;
    contentName = path.basename(f.path);
    contentSize = f.lengthSync();
    _loadMetadata();
  }

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

  String contentPath = '';
  String contentName = '';
  int contentSize = -1;
  String artist = '';
  String title = '';
  int trackNumber = -1;
  int bitRate = -1;
  String albumArtist = '';
  String albumTitle = '';

  // How to build a image class
  String albumCover = '';
  int albumYear = -1;
  int albumTrackCount = -1;
  String genre = '';
  String comment = '';
  int sampleRate = -1;
  int channels = -1;
  int length = -1;

  static int id = -1;

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

  void _loadMetadata() async {
    await Get.find<MetadataService>().readMetadata(this, loadImage: true);
  }
}
