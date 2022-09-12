import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as path;

class PlayContent {
  // PlayContent({
  //   required this.contentPath,
  //   required this.contentName,
  //   required this.contentSize,
  //   required this.artist,
  //   required this.title,
  //   required this.trackNumber,
  //   required this.bitRate,
  //   required this.albumArtist,
  //   required this.albumTitle,
  //   required this.albumCover,
  //   required this.albumYear,
  //   required this.albumTrackCount,
  //   required this.genre,
  //   required this.comment,
  //   required this.sampleRate,
  //   required this.channels,
  //   required this.length,
  // });
  
  PlayContent.fromEntry(FileSystemEntity file){
    if (file.statSync().type != FileSystemEntityType.file) {
      return;
    }
    File f = File(file.path);
    contentPath = f.path;
    contentName = path.split(f.path).last;
    contentSize = f.lengthSync();
  }

  String contentPath = "";
  String contentName = "";
  int contentSize = -1;
  String artist = "";
  String title = "";
  int trackNumber = -1;
  int bitRate = -1;
  String albumArtist = "";
  String albumTitle = "";
  // How to build a image class
  String albumCover = "";
  int albumYear = -1;
  int albumTrackCount = -1;
  String genre = "";
  String comment = "";
  int sampleRate = -1;
  int channels = -1;
  int length = -1;
}
