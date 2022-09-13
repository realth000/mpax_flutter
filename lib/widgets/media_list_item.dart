import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:path/path.dart' as path;

class MediaItemController extends GetxController {
  MediaItemController({required this.playContent});

  PlayerService playerService = Get.find<PlayerService>();
  PlayContent playContent;

  void play() {
    if (playContent.contentPath.isEmpty) {
      // Not play empty path.
      return;
    }
    playerService.play(playContent);
  }
}

class MediaItemTile extends StatelessWidget {
  MediaItemTile(this.playContent, {super.key}) {
    _controller = MediaItemController(playContent: playContent);
  }

  PlayContent playContent = PlayContent();
  MediaItemController _controller =
      MediaItemController(playContent: PlayContent());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(playContent.title == ""
          ? path.basename(playContent.contentPath)
          : playContent.title),
      subtitle: Text(playContent.contentPath),
      onTap: () {
        _controller.play();
      },
    );
  }
}
