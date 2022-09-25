import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/player_service.dart';

class _ProgressWidget extends GetView<PlayerService> {
  static const double height = 2.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Duration>(
      stream: controller.positionStream,
      builder: (context, snapshot) {
        if (controller.playerDuration() == null ||
            snapshot.hasError ||
            !snapshot.hasData) {
          return const LinearProgressIndicator(
            minHeight: height,
            value: 0.0,
          );
        }
        final v = (snapshot.data as Duration).inSeconds.toDouble() /
            controller.playerDuration()!.inSeconds.toDouble();
        // We remove the check and switch to next media here because in builder
        // there must NOT have something like "set".
        return LinearProgressIndicator(
          minHeight: height,
          value: v,
        );
      },
    );
  }
}

class MPaxPlayerWidget extends GetView<PlayerService> {
  const MPaxPlayerWidget({super.key});

  static const double widgetHeight = 70.0;

  String _getAlbumString() {
    if (controller.currentContent.value.artist.isNotEmpty) {
      return controller.currentContent.value.albumTitle;
    } else if (controller.currentContent.value.contentPath.isNotEmpty) {
      return controller.currentContent.value.contentPath
          .replaceFirst('/storage/emulated/0/', '');
    } else {
      return "";
    }
  }

  SizedBox _buildAudioAlbumCoverWidget(BuildContext context) {
    return SizedBox(
      width: widgetHeight - 10.0,
      height: widgetHeight - 10.0,
      child: Builder(
        builder: (BuildContext context) {
          if (controller.currentContent.value.albumCover.isEmpty) {
            return const Icon(Icons.music_note);
          } else {
            // return Image(image: Image.memory(controller
            //     .currentContent.value.albumCover.to))
            return const Icon(Icons.music_note);
          }
        },
      ),
    );
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
        onLongPressStart: (details) {
          // For animation.
        },
        onLongPressEnd: (details) {
          controller.seekToAnother(
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

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          // border: Border.all(
          // color: Colors.grey,
          // width: 2.0,
          // ),
          // borderRadius: BorderRadius.circular(1.0),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.grey,
          //   ),
          // ],
          ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: widgetHeight,
        ),
        child: Column(
          children: [
            _ProgressWidget(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Album cover
                  _buildAudioAlbumCoverWidget(context),
                  // Audio info
                  _buildAudioInfoWidget(context),
                  // Play-and-pause button.
                  IconButton(
                    onPressed: () {
                      controller.playOrPause();
                    },
                    icon: Obx(() => Icon(controller.playButtonIcon.value)),
                  ),
                  // Play mode button.
                  IconButton(
                    onPressed: () {
                      controller.switchPlayMode();
                    },
                    icon: Obx(() => Icon(controller.playModeIcon.value)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
