import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mobile/components/mobile_underfoot.dart';
import '../services/player_service.dart';
import '../widgets/media_list_item.dart';

/// Play content page, showing details about current playing audio.
class MusicPage extends GetView<PlayerService> {
  /// Constructor.
  const MusicPage({super.key});

  /// Define small space box width.
  static const spaceSmallWidth = 10.0;

  /// Define middle space box width.
  static const spaceMiddleWidth = 30.0;

  /// Define large space box width.
  static const spaceLargeWidth = 50.0;

  /// Define space box height.
  static const spaceHeight = 40.0;

  String _durationToString(Duration duration) {
    final secs = duration.inSeconds;
    if (secs == 0) {
      return '00:00';
    }
    return '${'${secs ~/ 60}'.padLeft(2, '0')}:'
        '${'${secs % 60}'.padLeft(2, '0')}';
  }

  SizedBox _buildSmallSpace() => const SizedBox(
        width: spaceSmallWidth,
        height: spaceHeight / 2,
      );

  SizedBox _buildMiddleSpace() => const SizedBox(
        width: spaceMiddleWidth,
        height: spaceHeight,
      );

  SizedBox _buildLargeSpace() => const SizedBox(
        width: spaceLargeWidth,
        height: spaceLargeWidth,
      );

  Widget _buildProgressRow(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildMiddleSpace(),
          Obx(
            () => Text(
              _durationToString(controller.currentPosition.value),
              maxLines: 1,
            ),
          ),
          Expanded(
            child: Obx(
              () => Slider(
                value: controller.currentPosition.value.inSeconds.toDouble(),
                max: (controller.currentDuration.value).inSeconds.toDouble(),
                onChanged: (value) async {
                  await controller.seekToDuration(
                    Duration(milliseconds: (value * 1000).toInt()),
                  );
                },
              ),
            ),
          ),
          Obx(
            () => Text(
              _durationToString(controller.currentDuration.value),
              maxLines: 1,
            ),
          ),
          _buildMiddleSpace(),
        ],
      );

  Widget _buildSeekDurationRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton(
            onPressed: () async {
              await controller.seekToDuration(
                Duration(
                  milliseconds:
                      controller.currentPosition.value.inMilliseconds - 5000,
                ),
              );
            },
            child: const Icon(Icons.replay_5),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.seekToDuration(
                Duration(
                  milliseconds:
                      controller.currentPosition.value.inMilliseconds + 5000,
                ),
              );
            },
            child: const Icon(Icons.forward_5),
          ),
        ],
      );

  Widget _buildControlRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSmallSpace(),
          ElevatedButton(
            onPressed: () async => Get.dialog(
              MediaMetadataDialog(controller.currentContent.value),
            ),
            child: const Icon(Icons.info_outlined),
          ),
          _buildSmallSpace(),
          ElevatedButton(
            onPressed: () async => controller.seekToAnother(false),
            child: const Icon(Icons.skip_previous),
          ),
          _buildSmallSpace(),
          ElevatedButton(
            onPressed: () async {
              await controller.playOrPause();
            },
            child: Obx(() => Icon(controller.playButtonIcon.value)),
          ),
          _buildSmallSpace(),
          ElevatedButton(
            onPressed: () async => controller.seekToAnother(true),
            child: const Icon(Icons.skip_next),
          ),
          _buildSmallSpace(),
          ElevatedButton(
            onPressed: () async {
              await controller.switchPlayMode();
            },
            child: Obx(() => Icon(controller.playModeIcon.value)),
          ),
          _buildSmallSpace(),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: ListTile(
            minLeadingWidth: 0,
            title: Obx(
              () => Text(
                controller.currentContent.value.title.isEmpty
                    ? controller.currentContent.value.contentName
                    : controller.currentContent.value.title,
                maxLines: 1,
              ),
            ),
            subtitle: Obx(
              () => Text(
                controller.currentContent.value.artist.isEmpty
                    ? ''
                    : controller.currentContent.value.artist,
                maxLines: 1,
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              _buildLargeSpace(),
              Expanded(
                child: SizedBox(
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
                ),
              ),
              _buildLargeSpace(),
              _buildProgressRow(context),
              _buildSmallSpace(),
              _buildSeekDurationRow(),
              _buildSmallSpace(),
              _buildControlRow(),
              _buildLargeSpace(),
            ],
          ),
        ),
        bottomNavigationBar:
            GetPlatform.isMobile ? const MobileUnderfoot() : null,
      );
}
