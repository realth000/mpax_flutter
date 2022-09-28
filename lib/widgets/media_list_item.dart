import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';
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
    await playerService.setCurrentContent(playContent, model);
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

  Widget _leadingIcon() {
    if (playContent.albumCover.isEmpty) {
      return const SizedBox(
        height: 56,
        width: 56,
        child: Icon(Icons.music_note),
      );
    }
    return SizedBox(
      height: 56,
      width: 56,
      child: Image.memory(
        base64Decode(playContent.albumCover),
        width: 60.0,
        height: 60.0,
        isAntiAlias: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ListTileLeading(child: _leadingIcon()),
      title: Text(
        playContent.title.isEmpty
            ? path.basename(playContent.contentPath)
            : playContent.title,
        maxLines: 1,
      ),
      subtitle: Text(
        playContent.albumTitle.isEmpty
            ? playContent.contentPath.replaceFirst('/storage/emulated/0/', '')
            : playContent.albumTitle,
        maxLines: 1,
      ),
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert),
      ),
      onTap: () async {
        await _controller.play();
      },
    );
  }
}
