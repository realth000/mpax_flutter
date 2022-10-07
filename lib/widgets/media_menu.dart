import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/play_content.model.dart';
import '../models/playlist.model.dart';
import '../widgets/util_widgets.dart';

/// Media context menu action types
enum MediaItemMenuActions {
  /// Start to play the item.
  play,

  /// Show the metadata in item.
  viewMetadata,
}

/// Build metadata menu.
class MediaItemMenu extends StatelessWidget {
  /// Constructor.
  const MediaItemMenu(this.playContent, this.playlist, {super.key});

  /// Audio content to build from.
  final PlayContent playContent;

  /// Playlist of the [playContent].
  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) => ModalDialog(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: Text('Play'.tr),
              onTap: () {
                Get.back(result: MediaItemMenuActions.play);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_attributes),
              title: Text('View metadata'.tr),
              onTap: () {
                Get.back(result: MediaItemMenuActions.viewMetadata);
              },
            ),
          ],
        ),
      );
}
