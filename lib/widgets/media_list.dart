import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/controllers/media_list_controller.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/utils/media_loader.dart';
import 'package:mpax_flutter/widgets/media_list_item.dart';

/// Media list widget, contains a list of audio content.
class MediaList extends StatelessWidget {
  /// Constructor.
  MediaList(Playlist playlist, {super.key}) {
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
                  controller.showList[i],
                  controller.playlist,
                );
              }
              return MediaItemTile(snapshot.data!, controller.playlist);
            },
          ),
        ),
      );
}
