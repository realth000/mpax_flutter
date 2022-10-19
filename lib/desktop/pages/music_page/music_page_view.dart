import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/player_service.dart';

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
  Widget build(BuildContext context) => SizedBox(
        width: Get.width / 4 * 3,
        height: Get.width / 4 * 3,
        child: Obx(
          () => controller.currentContent.value.albumCover.isEmpty
              ? const Icon(Icons.music_note)
              : Image.memory(
                  base64Decode(
                    controller.currentContent.value.albumCover,
                  ),
                ),
        ),
      );
}
