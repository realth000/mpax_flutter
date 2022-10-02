import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/widgets/media_list_item.dart';

class MusicPage extends GetView<PlayerService> {
  const MusicPage({super.key});

  static const spaceSmallWidth = 10.0;
  static const spaceMiddleWidth = 30.0;
  static const spaceLargeWidth = 50.0;
  static const spaceHeight = 40.0;

  String _durationToString(Duration duration) {
    final secs = duration.inSeconds;
    if (secs == 0) {
      return '00:00';
    }
    return '${'${secs ~/ 60}'.padLeft(2, '0')}:${'${secs % 60}'.padLeft(2, '0')}';
  }

  SizedBox _buildSmallSpace() {
    return const SizedBox(
      width: spaceSmallWidth,
      height: spaceHeight / 2,
    );
  }

  SizedBox _buildMiddleSpace() {
    return const SizedBox(
      width: spaceMiddleWidth,
      height: spaceHeight,
    );
  }

  SizedBox _buildLargeSpace() {
    return const SizedBox(
      width: spaceLargeWidth,
      height: spaceLargeWidth,
    );
  }

  Widget _buildProgressRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildMiddleSpace(),
        Obx(() => Text(
              _durationToString(controller.currentPosition.value),
              maxLines: 1,
            )),
        Expanded(
          child: Obx(() => Slider(
                value: controller.currentPosition.value.inSeconds.toDouble(),
                max: (controller.currentDuration.value).inSeconds.toDouble(),
                onChangeStart: (value) {
                  controller.durationSub.pause();
                  controller.positionSub.pause();
                },
                onChanged: (value) async {
                  await controller.seekToDuration(
                      Duration(milliseconds: (value * 1000).toInt()));
                },
                onChangeEnd: (value) {
                  controller.durationSub.resume();
                  controller.positionSub.resume();
                },
              )),
        ),
        Obx(() => Text(
              _durationToString(controller.currentDuration.value),
              maxLines: 1,
            )),
        _buildMiddleSpace(),
      ],
    );
  }

  Widget _buildControlRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSmallSpace(),
        ElevatedButton(
          onPressed: () =>
              Get.dialog(MediaMetadataDialog(controller.currentContent.value)),
          child: const Icon(Icons.info_outlined),
        ),
        _buildSmallSpace(),
        ElevatedButton(
          onPressed: () async => await controller.seekToAnother(false),
          child: const Icon(Icons.skip_previous),
        ),
        _buildSmallSpace(),
        ElevatedButton(
          onPressed: () {
            controller.playOrPause();
          },
          child: Obx(() => Icon(controller.playButtonIcon.value)),
        ),
        _buildSmallSpace(),
        ElevatedButton(
          onPressed: () async => await controller.seekToAnother(true),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          minLeadingWidth: 0.0,
          title: Obx(() => Text(
                controller.currentContent.value.title.isEmpty
                    ? controller.currentContent.value.contentName
                    : controller.currentContent.value.title,
                maxLines: 1,
              )),
          subtitle: Obx(() => Text(
                controller.currentContent.value.artist.isEmpty
                    ? ''
                    : controller.currentContent.value.artist,
                maxLines: 1,
              )),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLargeSpace(),
            Expanded(
              child: SizedBox(
                width: Get.width / 4 * 3,
                height: Get.width / 4 * 3,
                child:
                    Obx(() => controller.currentContent.value.albumCover.isEmpty
                        ? const Icon(Icons.music_note)
                        : Image.memory(
                            base64Decode(
                                controller.currentContent.value.albumCover),
                          )),
              ),
            ),
            _buildLargeSpace(),
            _buildProgressRow(context),
            _buildSmallSpace(),
            _buildControlRow(),
            _buildLargeSpace(),
          ],
        ),
      ),
    );
  }
}