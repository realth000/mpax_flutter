import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/desktop/pages/scaffold_pages.dart';

import '../themes/app_themes.dart';
import '../widgets/app_player_widget.dart';
import 'components/navigation_bar/navigation_bar_view.dart';
import 'components/window_bar_buttons/window_bar_buttons.dart';
import 'services/scaffold_service.dart';

/// Main scaffold use in desktop.
class MPaxScaffold extends GetView<ScaffoldService> {
  /// Constructor.
  const MPaxScaffold({super.key});

  Color _topBarColor(BuildContext context) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return MPaxTheme.flexDark.colorScheme.surface;
    } else {
      return MPaxTheme.flexLight.colorScheme.surface;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(
          children: <Widget>[
            Row(
              children: [
                MPaxNavigationBar(),
                MoveWindow(),
              ],
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  ColoredBox(
                    color: _topBarColor(context),
                    child: DesktopWindowButtons(),
                  ),
                  Expanded(
                    child: Obx(
                      () => ScaffoldPages.pages[controller.currentIndex.value],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: MPaxPlayerWidget(),
      );
}
