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

  void play() {
    if (playContent.contentPath.isEmpty) {
      // Not play empty path.
      return;
    }
    playerService.setCurrentContent(playContent, model);
    playerService.play();
  }
}

class MediaItemTile extends StatelessWidget {
  MediaItemTile(this.playContent, this.model, {super.key}) {
    _controller = MediaItemController(playContent, model);
  }

  PlayContent playContent = PlayContent();
  late final MediaItemController _controller;
  final PlaylistModel model;

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
