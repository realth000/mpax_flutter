import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

import 'taglib_bindings.dart';

class Metadata {
  Metadata({
    required this.title,
    required this.artist,
    required this.album,
    required this.track,
    required this.year,
    required this.genre,
    required this.comment,
    required this.sampleRate,
    required this.bitrate,
    required this.channels,
    required this.length,
    this.albumArtist,
    this.albumTotalTrack,
    this.lyrics,
    this.albumCover,
  });

  final String? title;
  final String? artist;
  final String? album;
  final String? albumArtist;
  final int? track;
  final int? albumTotalTrack;
  final int? year;
  final String? genre;
  final String? comment;
  final int? sampleRate;
  final int? bitrate;
  final int? channels;
  final int? length;
  final String? lyrics;
  final Uint8List? albumCover;
}

class TagLib {
  TagLib({required this.filePath});

  final String filePath;

  /// Read [Metadata] from file.
  Future<Metadata?> readMetadata() async {
    if (filePath.isEmpty) {
      return null;
    }
    final p = ReceivePort();
    await Isolate.spawn(_readMetadata, p.sendPort);
    return await p.first as Metadata?;
  }

  Future<dynamic> _readMetadata(SendPort p) async {
    try {
      final tagLib = NativeLibrary(
        Platform.isWindows
            ? DynamicLibrary.open('tag_c.dll')
            : DynamicLibrary.open('libtag_c.so'),
      );
      late final Pointer<Char> tagFileName;
      if (Platform.isWindows) {
        tagFileName = filePath.toNativeUtf8().cast();
//        final buffer = StringBuffer();
//        buffer.write tagFileName =
//            Pointer.fromAddress(filePath.toNativeUtf8().address);
        // tagFileName = malloc.allocate<Char>(100);
        // final listss = latin1.encode(filePath);
        // int i = 0;
        // for (; i < listss.length; i++) {
        //   tagFileName.elementAt(i).value = listss[i];
        // }
        // tagFileName.elementAt(i + 1).value = 0;
      } else {
        tagFileName = filePath.toNativeUtf8().cast();
      }
      final tagFile = tagLib.taglib_file_new(tagFileName);
      if (tagLib.taglib_file_is_valid(tagFile) == 0) {
        Isolate.exit(p);
      }
      final tagFileTag = tagLib.taglib_file_tag(tagFile);

      // Read common properties.
      // Read Title.
      final tagFileTagTitle = tagLib.taglib_tag_title(tagFileTag);
      // Read Artist.
      final tagFileTagArtist = tagLib.taglib_tag_artist(tagFileTag);
      // Read AlbumTitle.
      final tagFileTagAlbum = tagLib.taglib_tag_album(tagFileTag);
      // Read Track.
      final tagFileTagTrack = tagLib.taglib_tag_track(tagFileTag);
      // Read Year.
      final tagFileTagYear = tagLib.taglib_tag_year(tagFileTag);
      // Read Genre.
      final tagFileTagGenre = tagLib.taglib_tag_genre(tagFileTag);
      // Read Comment
      final tagFileTagComment = tagLib.taglib_tag_comment(tagFileTag);

      // Read audio properties.
      final tagProp = tagLib.taglib_file_audioproperties(tagFile);
      // Read SampleRate;
      final tagPropSampleRate =
          tagLib.taglib_audioproperties_samplerate(tagProp);
      // Read Bitrate.
      final tagPropBitrate = tagLib.taglib_audioproperties_bitrate(tagProp);
      // Read Channels.
      final tagPropChannels = tagLib.taglib_audioproperties_channels(tagProp);
      // Read Length.
      final tagPropLength = tagLib.taglib_audioproperties_length(tagProp);

      final metaData = Metadata(
        title: tagFileTagTitle.cast<Utf8>().toDartString(),
        artist: tagFileTagArtist.cast<Utf8>().toDartString(),
        album: tagFileTagAlbum.cast<Utf8>().toDartString(),
        track: tagFileTagTrack,
        year: tagFileTagYear,
        genre: tagFileTagGenre.cast<Utf8>().toDartString(),
        comment: tagFileTagComment.cast<Utf8>().toDartString(),
        sampleRate: tagPropSampleRate,
        bitrate: tagPropBitrate,
        channels: tagPropChannels,
        length: tagPropLength,
      );
//      malloc.free(tagProp);
//      malloc.free(tagFileTagComment);
//      malloc.free(tagFileTagGenre);
//      malloc.free(tagFileTagAlbum);
//      malloc.free(tagFileTagArtist);
//      malloc.free(tagFileTagTitle);
//      malloc.free(tagFileTag);
//      malloc.free(tagFile);
//      malloc.free(tagFileName);

      tagLib
        ..taglib_tag_free_strings()
//      tagLib.taglib_free(tagProp.cast<Void>());
//      tagLib.taglib_free(tagFileTagComment.cast<Void>());
//      tagLib.taglib_free(tagFileTagGenre.cast<Void>());
//      tagLib.taglib_free(tagFileTagAlbum.cast<Void>());
//      tagLib.taglib_free(tagFileTagArtist.cast<Void>());
//      tagLib.taglib_free(tagFileTagTitle.cast<Void>());
//      tagLib.taglib_free(tagFileTag.cast<Void>());
        ..taglib_file_free(tagFile);
      malloc.free(tagFileName);
      return Isolate.exit(p, metaData);
    } on PlatformException {
      print('Failed to read $PlatformException');
    }
    return Isolate.exit(p);
  }

  Future<Metadata?> readMetadataEx() async {
    if (filePath.isEmpty) {
      return null;
    }
    final p = ReceivePort();
    await Isolate.spawn(_readMetadataEx, p.sendPort);
    return await p.first as Metadata?;
  }

  Future<dynamic> _readMetadataEx(SendPort p) async {
    try {
      final meipuru = NativeLibrary(
        Platform.isWindows
            ? DynamicLibrary.open('libMeipuruLibC.dll')
            : DynamicLibrary.open('libMeipuruLibC.so'),
      );
      late final Pointer<Char> tagFileName;
      if (Platform.isWindows) {
        tagFileName = filePath.toNativeUtf8().cast();
      } else {
        tagFileName = filePath.toNativeUtf8().cast();
      }
      final originalTag = meipuru.MeipuruReadID3v2Tag(tagFileName);
      final id3v2Tag = originalTag.cast<MeipuruID3v2Tag>().ref;
      final metaData = Metadata(
        title: id3v2Tag.title.cast<Utf8>().toDartString(),
        artist: id3v2Tag.artist.cast<Utf8>().toDartString(),
        album: id3v2Tag.albumTitle.cast<Utf8>().toDartString(),
        track: id3v2Tag.track,
        year: id3v2Tag.year,
        genre: id3v2Tag.genre.cast<Utf8>().toDartString(),
        comment: id3v2Tag.comment.cast<Utf8>().toDartString(),
        sampleRate: id3v2Tag.sampleRate,
        bitrate: id3v2Tag.bitRate,
        channels: id3v2Tag.channels,
        length: id3v2Tag.length,
        albumArtist: id3v2Tag.albumArtist.cast<Utf8>().toDartString(),
        albumTotalTrack: id3v2Tag.albumTotalTrack,
        lyrics: id3v2Tag.lyrics
            .cast<Utf8>()
            .toDartString(length: id3v2Tag.lyricsLength),
        albumCover: id3v2Tag.albumCover
            .cast<Uint8>()
            .asTypedList(id3v2Tag.albumCoverLength),
      );
      meipuru.MeipuruFree(originalTag.cast());
      return Isolate.exit(p, metaData);
    } catch (e) {
      print('Error in readMetadataEx: $e');
    }
  }
}
