import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/widgets/media_list_item.dart';

class MusicPage extends GetView<PlayerService> {
  MusicPage({super.key});

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
      height: spaceHeight,
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
        StreamBuilder<Duration>(
          stream: controller.positionStream,
          builder: (context, snapshot) {
            if (snapshot.data == null ||
                snapshot.hasError ||
                !snapshot.hasData) {
              return const Text('00:00');
            }
            return Text(_durationToString(snapshot.data!));
          },
        ),
        _buildSmallSpace(),
        Expanded(
          child: Obx(() => Slider(
                value: controller.currentPosition.value.inSeconds.toDouble(),
                // value: controller.positionStream.listen((event) {}),
                max: (controller.currentDuration.value ??
                        controller.currentPosition.value)
                    .inSeconds
                    .toDouble(),
                onChanged: (value) {
                  print('AAAA');
                },
              )),
        ),
        _buildSmallSpace(),
        StreamBuilder<Duration?>(
            stream: controller.durationStream,
            builder: (context, snapshot) {
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return const Text('??:??');
              }
              return Text(_durationToString(snapshot.data!));
            }),
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
            SizedBox(
              width: Get.width / 3 * 2,
              height: Get.width / 3 * 2,
              child: Obx(() =>
                  controller.currentContent.value.albumCover.isEmpty
                      ? const Icon(Icons.music_note)
                      : Image.memory(base64Decode(
                          controller.currentContent.value.albumCover))),
            ),
            _buildLargeSpace(),
            _buildProgressRow(context),
            _buildLargeSpace(),
            _buildControlRow(),
          ],
        ),
      ),
    );
  }
}
