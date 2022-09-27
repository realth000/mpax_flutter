import 'dart:convert';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mpax_flutter/models/play_content.model.dart';

class MetadataService extends GetxService {
  Future<void> readMetadata(PlayContent playContent,
      {bool loadImage = false, bool scaleImage = true}) async {
    final s = await File(playContent.contentPath).stat();
    if (s.type != FileSystemEntityType.file) {
      return;
    }
    final metadata = await MetadataGod.getMetadata(playContent.contentPath);
    if (metadata == null) {
      return;
    }
    _applyMetadata(playContent, metadata, loadImage, scaleImage);
    return;
  }

  Future<void> _applyMetadata(PlayContent playContent, Metadata metadata,
      bool loadImage, bool scaleImage) async {
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
    if (metadata.genre != null) {
      playContent.genre = metadata.genre!;
    }
    if (metadata.picture == null || !loadImage) {
      return;
    }
    if (scaleImage) {
      final tmpList = await FlutterImageCompress.compressWithList(
        metadata.picture!.data,
        minWidth: 240,
        minHeight: 240,
      );
      playContent.albumCover = base64Encode(tmpList);
    } else {
      // playContent.albumCover = String.fromCharCodes(metadata.picture!.data);
      playContent.albumCover = base64Encode(metadata.picture!.data);
    }
  }

  Future<MetadataService> init() async {
    return this;
  }
}
