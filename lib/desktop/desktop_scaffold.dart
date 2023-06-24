import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/desktop/components/navigation_bar/navigation_bar_view.dart';
import 'package:mpax_flutter/desktop/pages/scaffold_pages.dart';
import 'package:mpax_flutter/desktop/services/scaffold_service.dart';
import 'package:mpax_flutter/services/settings_service.dart';
import 'package:mpax_flutter/themes/app_themes.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';

/// Main scaffold use in desktop.
class MPaxScaffold extends GetView<ScaffoldService> {
  /// Constructor.
  MPaxScaffold({super.key});

  // Read settings from store.
  final _settingsService = Get.find<SettingsService>();

  Color _topBarColor(BuildContext context) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark) {
      return MPaxTheme.flexDark.colorScheme.surface;
    } else {
      return MPaxTheme.flexLight.colorScheme.surface;
    }
  }

  List<Widget> _buildBody(BuildContext context, bool useNative) {
    final navigationColumn = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 90),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 280, // 272
            ),
            child: MPaxNavigationBar(),
          ),
        ],
      ),
    );

    return [
      navigationColumn,
      Expanded(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Obx(
                () => ScaffoldPages.pages[controller.currentIndex.value],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Obx(
          () => Row(
            children: _buildBody(
              context,
              _settingsService.desktopUseNativeTittleBar.value,
            ),
          ),
        ),
        bottomNavigationBar: const MPaxPlayerWidget(),
      );
}
