import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/player_service.dart';

class _ProgressWidget extends GetView<PlayerService> {
  static const double height = 2;

  @override
  Widget build(BuildContext context) => Obx(
        () => LinearProgressIndicator(
          minHeight: height,
          value: controller.currentPosition.value.inSeconds.toDouble() /
              controller.currentDuration.value.inSeconds.toDouble(),
          backgroundColor: Colors.transparent,
        ),
      );
}

class _DesktopProgressWidget extends GetView<PlayerService> {
  @override
  Widget build(BuildContext context) => Obx(
        () => Slider(
          value: controller.currentPosition.value.inSeconds.toDouble(),
          max: (controller.currentDuration.value).inSeconds.toDouble(),
          onChangeStart: (value) {
            controller.durationSub.pause();
            controller.positionSub.pause();
          },
          onChanged: (value) async {
            await controller.seekToDuration(
              Duration(milliseconds: (value * 1000).toInt()),
            );
          },
          onChangeEnd: (value) {
            controller.durationSub.resume();
            controller.positionSub.resume();
          },
        ),
      );
}

/// Player widget, at bottom of most pages.
class MPaxPlayerWidget extends GetView<PlayerService> {
  /// Constructor.
  const MPaxPlayerWidget({super.key});

  /// Player wight height.
  static const double widgetHeight = 70;

  /// Album image height.
  static const double albumCoverHeight = 56;

  String _getAlbumString() {
    if (controller.currentContent.value.artist.isNotEmpty) {
      return controller.currentContent.value.albumTitle;
    } else if (controller.currentContent.value.contentPath.isNotEmpty) {
      return controller.currentContent.value.contentPath
          .replaceFirst('/storage/emulated/0/', '');
    } else {
      return '';
    }
  }

  Widget _buildAudioAlbumCoverWidget(BuildContext context) {
    if (controller.currentContent.value.albumCover.isEmpty) {
      return const SizedBox(
        width: albumCoverHeight,
        height: albumCoverHeight,
        child: Icon(Icons.music_note),
      );
    } else {
      return GestureDetector(
        onTapUp: (details) async {
          await Get.toNamed(MPaxRoutes.music);
        },
        child: SizedBox(
          width: albumCoverHeight,
          height: albumCoverHeight,
          child: Image.memory(
            base64Decode(controller.currentContent.value.albumCover),
          ),
        ),
      );
    }
  }

  Expanded _buildAudioInfoWidget(BuildContext context) {
    final titleWidget = Expanded(
      child: Obx(
        () => Text(
          controller.currentContent.value.title.isEmpty
              ? controller.currentContent.value.contentName
              : controller.currentContent.value.title,
          textAlign: TextAlign.left,
          maxLines: 1,
        ),
      ),
    );

    final artistWidget = Expanded(
      child: Obx(
        () => Text(
          controller.currentContent.value.artist.isEmpty
              ? ''
              : controller.currentContent.value.artist,
          textAlign: TextAlign.left,
          maxLines: 1,
        ),
      ),
    );

    final albumWidget = Expanded(
      child: Obx(
        () => Text(
          _getAlbumString(),
          textAlign: TextAlign.left,
          maxLines: 1,
        ),
      ),
    );

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) async {
          await Get.toNamed(MPaxRoutes.music);
        },
        onLongPressStart: (details) {
          // For animation.
        },
        onLongPressEnd: (details) async {
          if (details.localPosition.dy < 0) {
            return;
          }
          await controller.seekToAnother(
            details.globalPosition.dx >= context.width / 2,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                titleWidget,
                artistWidget,
                albumWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile(BuildContext context) => Column(
        children: [
          _ProgressWidget(),
          Expanded(
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: widgetHeight - albumCoverHeight + 2,
                ),
                // Album cover
                Obx(() => _buildAudioAlbumCoverWidget(context)),
                const SizedBox(
                  width: widgetHeight / 2 - albumCoverHeight / 2,
                ),
                // Audio info
                _buildAudioInfoWidget(context),
                // Play-and-pause button.
                ElevatedButton(
                  onPressed: () async {
                    await controller.playOrPause();
                  },
                  child: Obx(() => Icon(controller.playButtonIcon.value)),
                ),
                const SizedBox(
                  width: 5,
                  height: 5,
                ),
                // Play mode button.
                ElevatedButton(
                  onPressed: () async {
                    await controller.switchPlayMode();
                  },
                  child: Obx(() => Icon(controller.playModeIcon.value)),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildVolumeController() => Obx(
        () => Slider(
          value: controller.volume.value,
          onChanged: (value) async {
            await controller.saveVolume(value);
          },
        ),
      );

  Widget _buildControlButtons() => Row(
        children: <Widget>[
          // Play-and-pause button.
          ElevatedButton(
            onPressed: () async => controller.seekToAnother(false),
            child: const Icon(Icons.skip_previous),
          ),
          const SizedBox(
            width: 5,
            height: 5,
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.playOrPause();
            },
            child: Obx(() => Icon(controller.playButtonIcon.value)),
          ),
          const SizedBox(
            width: 5,
            height: 5,
          ),
          ElevatedButton(
            onPressed: () async => controller.seekToAnother(true),
            child: const Icon(Icons.skip_next),
          ),
          const SizedBox(
            width: 5,
            height: 5,
          ),
          // Play mode button.
          ElevatedButton(
            onPressed: () async {
              await controller.switchPlayMode();
            },
            child: Obx(() => Icon(controller.playModeIcon.value)),
          ),
          const SizedBox(
            width: 15,
            height: 15,
          ),
        ],
      );

  Widget _buildDesktop(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: widgetHeight - albumCoverHeight + 2,
            ),
            // Album cover
            Obx(() => _buildAudioAlbumCoverWidget(context)),
            const SizedBox(
              width: widgetHeight / 2 - albumCoverHeight / 2,
            ),
            // Audio info
            SizedBox(
              width: 100,
              height: 100,
              child: Row(
                children: [
                  _buildAudioInfoWidget(context),
                ],
              ),
            ),
            Expanded(child: _DesktopProgressWidget()),
            const SizedBox(
              width: 5,
              height: 5,
            ),
            _buildVolumeController(),
            const SizedBox(
              width: 5,
              height: 5,
            ),
            _buildControlButtons(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: widgetHeight,
        ),
        child: GetPlatform.isMobile
            ? _buildMobile(context)
            : _buildDesktop(context),
      );
}
