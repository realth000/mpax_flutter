import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/widgets/lyric_widget.dart';

/// Music page for desktop platforms.
///
/// Will have normal, full-window and full-screen total three forms in future.
/// Normal: Use and the body of app scaffold.
/// Full-window: Fill the window off application, have window control buttons
/// and backward button at top.
/// Full-screen: Fill current screen, have backward button at top.
///
/// Now only have normal state.
/// Lyric also need to show in this page.
class DesktopMusicPage extends GetView<PlayerService> {
  /// Constructor.
  const DesktopMusicPage({super.key});

  @override
  Widget build(BuildContext context) => Flex(
        direction: Axis.horizontal,
        children: [
          const SizedBox(
            width: 10,
            height: 10,
          ),
          SizedBox(
            width: Get.width / 3 * 1,
            height: Get.width / 3 * 1,
            child: Obx(
              () => controller.currentMusic.value.artworkList.isEmpty
                  ? const Icon(Icons.music_note)
                  : Image.memory(
                      base64Decode(Get.find<DatabaseService>()
                              .findArtworkDataByTypeIdSync(controller
                                  .currentMusic.value.artworkList
                                  .elementAtOrNull(0)) ??
                          ''),
                    ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: LyricWidget(),
            ),
          ),
        ],
      );
}
