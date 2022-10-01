import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mpax_flutter/models/play_content.model.dart';

class MetadataService extends GetxService {
  Future<PlayContent> readMetadata(String contentPath,
      {bool loadImage = false, bool scaleImage = true}) async {
    final s = await File(contentPath).stat();
    if (s.type != FileSystemEntityType.file) {
      return PlayContent();
    }
    final metadata = await MetadataGod.getMetadata(contentPath);
    if (metadata == null) {
      return PlayContent.fromPath(contentPath);
    }
    return await _applyMetadata(contentPath, metadata, loadImage, scaleImage);
  }

  Future<PlayContent> _applyMetadata(String contentPath, Metadata metadata,
      bool loadImage, bool scaleImage) async {
    PlayContent playContent = PlayContent.fromPath(contentPath);
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
    return playContent;
  }

  Future<MetadataService> init() async {
    return this;
  }
}
