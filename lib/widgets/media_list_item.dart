import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:path/path.dart' as path;

class MediaItemController extends GetxController {
  MediaItemController(this.playContent, this.model);

  PlayerService playerService = Get.find<PlayerService>();
  PlayContent playContent;
  PlaylistModel model;

  Future<void> play() async {
    if (playContent.contentPath.isEmpty) {
      // Not play empty path.
      return;
    }
    playerService.setCurrentContent(playContent, model);
    await playerService.play();
  }
}

class MediaItemTile extends StatelessWidget {
  MediaItemTile(this.playContent, this.model, {super.key}) {
    _controller = MediaItemController(playContent, model);
  }

  final PlayContent playContent;
  late final MediaItemController _controller;
  final PlaylistModel model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.music_note),
        ],
      ),
      title: Text(
        playContent.title == ""
            ? path.basename(playContent.contentPath)
            : playContent.title,
      ),
      subtitle: Text(
        playContent.contentPath.replaceFirst('/storage/emulated/0/', ''),
      ),
      onTap: () async {
        await _controller.play();
      },
    );
  }
}
