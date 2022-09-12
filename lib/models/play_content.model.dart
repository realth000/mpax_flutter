import 'dart:io';

import 'package:path/path.dart' as path;

class PlayContent {
  PlayContent.fromEntry(FileSystemEntity file) {
    if (file.statSync().type != FileSystemEntityType.file) {
      return;
    }
    File f = File(file.path);
    contentPath = f.path;
    contentName = path.split(f.path).last;
    contentSize = f.lengthSync();
  }

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
}
