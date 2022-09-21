import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:path/path.dart' as path;

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
          maxHeight: 70.0,
        ),
        child: Column(
          children: [
            _ProgressWidget(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
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
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    controller
                                            .currentContent.value.title.isEmpty
                                        ? controller
                                            .currentContent.value.contentName
                                        : controller.currentContent.value.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    controller
                                            .currentContent.value.artist.isEmpty
                                        ? ''
                                        : controller
                                            .currentContent.value.artist,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => Text(
                                    controller.currentContent.value.albumTitle
                                            .isEmpty
                                        ? path.dirname(
                                            controller.currentContent.value
                                                .contentPath,
                                          )
                                        : controller
                                            .currentContent.value.albumTitle,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.playOrPause();
                    },
                    icon: Obx(() => Icon(controller.playButtonIcon.value)),
                  ),
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
