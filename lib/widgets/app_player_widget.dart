import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/player_service.dart';

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
                onHorizontalDragStart: (DragStartDetails details) {
                  controller.recordDragStart(details);
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  controller.updateDrag(details);
                },
                onHorizontalDragEnd: (DragEndDetails details) {
                  controller.checkDragEnd(details);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Obx(
                    () => Align(
                      alignment: controller.infoAlignment.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Obx(
                              () => Text(
                                "${controller.titleText}",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => Text(
                                "${controller.artistText}",
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => Text(
                                "${controller.albumText}",
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
