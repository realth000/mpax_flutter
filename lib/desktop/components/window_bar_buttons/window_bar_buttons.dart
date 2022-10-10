import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Buttons and button styles used in desktop window title bar.
class DesktopWindowButtons extends StatelessWidget {
  /// Constructor.
  DesktopWindowButtons({super.key});

  /// Button colors.
  final buttonColors = WindowButtonColors(
    normal: Colors.transparent,
    iconNormal: Get.theme.colorScheme.primary,
    mouseOver: Get.theme.colorScheme.primary.withOpacity(0.6),
    mouseDown: Get.theme.colorScheme.primary.withOpacity(0.3),
  );

  /// Close button colors.
  final closeButtonColors = WindowButtonColors(
    normal: Colors.transparent,
    iconNormal: Get.theme.colorScheme.primary,
    mouseOver: Colors.red.withOpacity(0.9),
    mouseDown: Colors.red.withOpacity(0.7),
  );

  @override
  Widget build(BuildContext context) => WindowTitleBarBox(
        child: Row(
          children: <Widget>[
            Expanded(
              child: MoveWindow(),
            ),
            MinimizeWindowButton(
              colors: buttonColors,
            ),
            MaximizeWindowButton(
              colors: buttonColors,
            ),
            CloseWindowButton(
              colors: closeButtonColors,
            ),
          ],
        ),
      );
}
