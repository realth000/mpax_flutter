import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/media_list_controller.dart';
import '../models/playlist_model.dart';
import '../utils/media_loader.dart';
import '../widgets/media_list_item.dart';

/// Media list widget, contains a list of audio content.
class MediaList extends StatelessWidget {
  /// Constructor.
  MediaList(PlaylistModel playlist, {super.key}) {
    Get.put(MediaListController(playlist));
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
