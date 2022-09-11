import 'dart:ui';

class PlayContent {
  PlayContent({
    required this.contentPath,
    required this.contentName,
    required this.contentSize,
    required this.artist,
    required this.title,
    required this.trackNumber,
    required this.bitRate,
    required this.albumArtist,
    required this.albumTitle,
    required this.albumCover,
    required this.albumYear,
    required this.albumTrackCount,
    required this.genre,
    required this.comment,
    required this.sampleRate,
    required this.channels,
    required this.length,
  });

  String contentPath;
  String contentName;
  int contentSize;
  String artist;
  String title;
  int trackNumber;
  int bitRate;
  String albumArtist;
  String albumTitle;
  Image albumCover;
  int albumYear;
  int albumTrackCount;
  String genre;
  String comment;
  int sampleRate;
  int channels;
  int length;
}
