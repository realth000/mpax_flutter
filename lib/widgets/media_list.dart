import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/media_list_controller.dart';
import '../mobile/services/media_query_service.dart';
import '../models/play_content.model.dart';
import '../models/playlist.model.dart';
import '../services/metadata_service.dart';
import '../widgets/media_list_item.dart';

/// Media list widget, contains a list of audio content.
class MediaList extends StatelessWidget {
  /// Constructor.
  MediaList(PlaylistModel playlist, {super.key}) {
    Get.put(MediaListController(playlist));
  }

  final _metadataService = Get.find<MetadataService>();

  final _mediaQueryService = Get.find<MediaQueryService>();

  /// Reload audio info;
  Future<PlayContent> reloadContent(PlayContent playContent) async {
    // Load album cover from file.
    final p = await _metadataService.readMetadata(
      playContent.contentPath,
      loadImage: true,
    );
    if (p.albumCover.isNotEmpty) {
      playContent.albumCover = p.albumCover;
      return playContent;
    }
    // Load album cover from Android media store.
    final am = _mediaQueryService.audioList.firstWhereOrNull(
      (audio) => audio.data == playContent.contentPath,
    );
    if (am != null) {
      final albumCover = await _mediaQueryService.loadAlbumCover(am);
      if (albumCover.isNotEmpty) {
        playContent.albumCover = albumCover;
      }
    }
    return playContent;
  }

  @override
  Widget build(BuildContext context) => GetBuilder<MediaListController>(
        builder: (controller) => ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.showList.length,
          itemBuilder: (context, i) => FutureBuilder(
            future: reloadContent(controller.showList[i]),
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return MediaItemTile(
                    controller.showList[i], controller.playlist);
              }
              return MediaItemTile(snapshot.data!, controller.playlist);
            },
          ),
        ),
      );
}
