import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';

enum MediaItemMenuActions {
  play,
  viewMetadata,
}

class MediaItemMenu extends StatelessWidget {
  const MediaItemMenu(this.playContent, this.playlist, {super.key});

  final PlayContent playContent;
  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    return ModalDialog(
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
}
