import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:path/path.dart' as path;

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
          maxHeight: 60.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPressStart: (LongPressStartDetails details) {
                  // For animation.
                },
                onLongPressEnd: (LongPressEndDetails details) async {
                  await controller.switchToSiblingMedia(
                      details.globalPosition.dx >= context.width / 2);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.content.value.title.isEmpty
                                  ? controller.content.value.contentName
                                  : controller.content.value.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.content.value.artist.isEmpty
                                  ? "Unknown".tr
                                  : controller.content.value.artist,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => Text(
                              controller.content.value.albumTitle.isEmpty
                                  ? path.dirname(
                                      controller.content.value.contentPath)
                                  : controller.content.value.albumTitle,
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
    );
  }
}
