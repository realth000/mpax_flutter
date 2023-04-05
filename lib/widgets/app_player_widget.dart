import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../desktop/services/scaffold_service.dart';
import '../models/music_model.dart';
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
          onChanged: (value) async {
            await controller.seekToDuration(
              Duration(milliseconds: (value * 1000).toInt()),
            );
          },
        ),
      );
}

/// Player widget, at bottom of most pages.
class MPaxPlayerWidget extends GetView<PlayerService> {
  /// Constructor.
  const MPaxPlayerWidget({super.key});

  /// Player wight height.
  static final double widgetHeight = GetPlatform.isMobile ? 70 : 140;

  /// Album image height.
  static final double albumCoverHeight = GetPlatform.isMobile ? 56 : 120;

  Future<void> _toMusicPage() async {
    if (GetPlatform.isMobile) {
      await Get.toNamed(MPaxRoutes.music);
    } else {
      Get.find<ScaffoldService>().currentIndex.value = 2;
    }
  }

  /// Transform duration to readable time [String].
  /// TODO: Duplicate with the same util function in mobile music page.
  String _durationToString(Duration duration) {
    final secs = duration.inSeconds;
    if (secs == 0) {
      return '00:00';
    }
    return '${'${secs ~/ 60}'.padLeft(2, '0')}:'
        '${'${secs % 60}'.padLeft(2, '0')}';
  }

  Widget _buildAudioAlbumCoverWidget(BuildContext context) {
    if (controller.currentMusic.value.artworkList.isEmpty) {
      return GestureDetector(
        onTapUp: (details) async {
          await _toMusicPage();
        },
        child: SizedBox(
          width: albumCoverHeight,
          height: albumCoverHeight,
          child: const Icon(Icons.music_note),
        ),
      );
    } else {
      return GestureDetector(
        onTapUp: (details) async {
          await _toMusicPage();
        },
        child: SizedBox(
          width: albumCoverHeight,
          height: albumCoverHeight,
          child: Image.memory(
            base64Decode(
              controller.currentMusic.value.artworkList
                      .elementAtOrNull(0)
                      ?.artwork
                      .value
                      ?.data ??
                  '',
            ),
          ),
        ),
      );
    }
  }

  String _musicTitle(Music music) {
    if (music.title == null) {
      return music.fileName;
    }
    if (music.title!.isEmpty) {
      return music.fileName;
    }
    return music.title!;
  }

  Widget _buildAudioInfoWidget(BuildContext context) {
    final music = controller.currentMusic;
    final titleWidget = Obx(
      () => Text(
        _musicTitle(music.value),
        style: const TextStyle(
          fontSize: 15,
        ),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );

    final artistWidget = Obx(
      () => Text(
        music.value.artists.isEmpty
            ? ''
            : music.value.artists
                .toList()
                .map((a) => a.name)
                .toList()
                .join(', '),
        style: TextStyle(
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );

    final albumWidget = Obx(
      () => Text(
        controller.currentMusic.value.album.value?.title ??
            controller.currentMusic.value.filePath
                .replaceFirst('/storage/emulated/0/', ''),
        style: TextStyle(
          color: Colors.grey[600],
        ),
        textAlign: TextAlign.left,
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 2),
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
    );
  }

  Widget _buildMobile(BuildContext context) => Column(
        children: [
          _ProgressWidget(),
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 10),
                  child: // Album cover
                      Obx(() => _buildAudioAlbumCoverWidget(context)),
                ),
                // Audio info
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) async {
                      await _toMusicPage();
                    },
                    onLongPressEnd: (details) async {
                      if (details.localPosition.dy < 0) {
                        return;
                      }
                      await controller.seekToAnother(
                        details.globalPosition.dx >= context.width / 2,
                      );
                    },
                    child: _buildAudioInfoWidget(context),
                  ),
                ),
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

  Widget _buildVolumeIcon() {
    if (controller.volume.value.isEqual(0)) {
      return const Icon(Icons.volume_mute);
    }
    if (controller.volume.value < 0.3) {
      return const Icon(Icons.volume_down);
    }
    return const Icon(Icons.volume_up);
  }

  Widget _buildVolumeController() => Obx(
        () => Row(
          children: <Widget>[
            IconButton(
              onPressed: () async {
                if (!controller.volume.value.isEqual(0)) {
                  controller.volumeBeforeMute = controller.volume.value;
                  await controller.saveVolume(0);
                } else {
                  await controller.saveVolume(controller.volumeBeforeMute);
                }
              },
              icon: _buildVolumeIcon(),
            ),
            Slider(
              value: controller.volume.value,
              onChanged: (value) async {
                await controller.saveVolume(value);
              },
            ),
          ],
        ),
      );

  Widget _buildControlRow() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildControlButtons(),
          const SizedBox(
            width: 5,
            height: 5,
          ),
          Obx(
            () => Text(
              _durationToString(controller.currentPosition.value),
              maxLines: 1,
            ),
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          Expanded(
            child: _DesktopProgressWidget(),
          ),
          const SizedBox(
            width: 10,
            height: 10,
          ),
          Obx(
            () => Text(
              _durationToString(controller.currentDuration.value),
              maxLines: 1,
            ),
          ),
          const SizedBox(
            width: 15,
            height: 15,
          ),
        ],
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
            width: 5,
            height: 5,
          ),
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
          const SizedBox(
            width: 5,
            height: 5,
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
            // Album cover
            Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() => _buildAudioAlbumCoverWidget(context)),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Audio info
                      Expanded(
                        child: _buildAudioInfoWidget(context),
                      ),
                      const SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      _buildVolumeController(),
                    ],
                  ),
                  Expanded(
                    child: _buildControlRow(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widgetHeight,
        ),
        child: GetPlatform.isMobile
            ? _buildMobile(context)
            : Stack(
                children: [
                  _buildDesktop(context),
                  MoveWindow(),
                ],
              ),
      );
}
