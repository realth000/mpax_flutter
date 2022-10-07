import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart' as fmm;
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart' as mg;

import '../models/play_content.model.dart';

/// Manage audio metadata, globally.
class MetadataService extends GetxService {
  /// Get a [PlayContent] filled with metadata read from given [contentPath].
  Future<PlayContent> readMetadata(
    String contentPath, {
    bool loadImage = false,
    bool scaleImage = true,
  }) async {
    final s = File(contentPath).statSync();
    if (s.type != FileSystemEntityType.file) {
      return PlayContent();
    }

    // late final Metadata metadata;
    late final mg.Metadata? metadata;
    try {
      metadata = await mg.MetadataGod.getMetadata(contentPath);
      if (metadata == null) {
        return PlayContent.fromPath(contentPath);
      }
    } catch (e) {
      // May have ffi exception.
      // Can not read metadata, maybe from m4a files.
      //   Only write basic info.
      //   TODO: Should print something here.
      return PlayContent.fromPath(contentPath);
    }
    return _applyMetadataFromMG(contentPath, metadata, loadImage, scaleImage);

    // NOT USED.
    if (GetPlatform.isMobile) {
      // late final Metadata metadata;
      late final fmm.Metadata? metadata;
      try {
        metadata = await fmm.MetadataRetriever.fromFile(File(contentPath));
      } catch (e) {
        // Can not read metadata, maybe from m4a files.
        //   Only write basic info.
        //   TODO: Should print something here.
        return PlayContent.fromPath(contentPath);
      }
      return await _applyMetadataFromFMM(
          contentPath, metadata, loadImage, scaleImage);
    } else {
      // late final Metadata metadata;
      late final mg.Metadata? metadata;
      try {
        metadata = await mg.MetadataGod.getMetadata(contentPath);
        if (metadata == null) {
          return PlayContent.fromPath(contentPath);
        }
      } catch (e) {
        // Can not read metadata, maybe from m4a files.
        //   Only write basic info.
        //   TODO: Should print something here.
        return PlayContent.fromPath(contentPath);
      }
      return await _applyMetadataFromMG(
          contentPath, metadata, loadImage, scaleImage);
    }
  }

  /// Fetch metadata with package flutter_media_metadata.
  Future<PlayContent> _applyMetadataFromFMM(String contentPath,
      fmm.Metadata metadata, bool loadImage, bool scaleImage) async {
    var playContent = PlayContent.fromPath(contentPath);
    try {
      if (metadata.authorName != null) {
        playContent.artist = metadata.authorName!;
      }
      if (metadata.trackName != null) {
        playContent.title = metadata.trackName!;
      }
      if (metadata.trackNumber != null) {
        playContent.trackNumber = metadata.trackNumber!;
      }
      if (metadata.albumArt != null) {
        playContent.albumArtist = metadata.albumArt!.join(',');
      }
      if (metadata.albumName != null) {
        playContent.albumTitle = metadata.albumName!;
      }
      if (metadata.year != null) {
        playContent.albumYear = metadata.year!;
      }
      if (metadata.trackNumber != null) {
        playContent.albumTrackCount = metadata.trackNumber!;
      }
      // FIXME: Seems some files have a genre value ' ',
      // is blank but contains a space.
      // Do not know is id3 tag standard or file corruption or mis-edit,
      // just filter this situation now.
      if (metadata.genre != null && metadata.genre != ' ') {
        playContent.genre = metadata.genre!;
      }
      if (metadata.bitrate != null) {
        playContent.bitRate = metadata.bitrate!;
      }

      if (metadata.albumArt == null || !loadImage) {
        return playContent;
      }
      if (scaleImage) {
        final tmpList = await FlutterImageCompress.compressWithList(
          metadata.albumArt!,
          minWidth: 240,
          minHeight: 240,
        );
        playContent.albumCover = base64Encode(tmpList);
        // playContent.albumCover = base64Encode(metadata.picture!.data);
      } else {
        // playContent.albumCover = String.fromCharCodes(metadata.picture!.data);
        playContent.albumCover = base64Encode(metadata.albumArt!);
      }
    } catch (e) {
      return PlayContent.fromPath(contentPath);
    }
    return playContent;
  }

  /// Fetch metadata with package metadata_god.
  Future<PlayContent> _applyMetadataFromMG(String contentPath,
      mg.Metadata metadata, bool loadImage, bool scaleImage) async {
    var playContent = PlayContent.fromPath(contentPath);
    try {
      if (metadata.artist != null) {
        playContent.artist = metadata.artist!;
      }
      if (metadata.title != null) {
        playContent.title = metadata.title!;
      }
      if (metadata.trackNumber != null) {
        playContent.trackNumber = metadata.trackNumber!;
      }
      if (metadata.albumArtist != null) {
        playContent.albumArtist = metadata.albumArtist!;
      }
      if (metadata.album != null) {
        playContent.albumTitle = metadata.album!;
      }
      if (metadata.year != null) {
        playContent.albumYear = metadata.year!;
      }
      if (metadata.trackTotal != null) {
        playContent.albumTrackCount = metadata.trackTotal!;
      }
      // FIXME: Seems some files have a genre value ' ',
      // is blank but contains a space.
      // Do not know is id3 tag standard or file corruption or mis-edit,
      // just filter this situation now.
      if (metadata.genre != null && metadata.genre != ' ') {
        playContent.genre = metadata.genre!;
      }
      // if (metadata.bitrate != null) {
      //   playContent.bitRate = metadata.bitrate!;
      // }

      if (metadata.picture == null || !loadImage) {
        return playContent;
      }

      if (scaleImage) {
        final tmpList = await FlutterImageCompress.compressWithList(
          metadata.picture!.data,
          minWidth: 240,
          minHeight: 240,
        );
        playContent.albumCover = base64Encode(tmpList);
        // playContent.albumCover = base64Encode(metadata.picture!.data);
      } else {
        // playContent.albumCover = String.fromCharCodes(metadata.picture!.data);
        playContent.albumCover = base64Encode(metadata.picture!.data);
      }
    } catch (e) {
      return PlayContent.fromPath(contentPath);
    }
    return playContent;
  }

  /// Init function, run before app start.
  Future<MetadataService> init() async {
    return this;
  }
}
