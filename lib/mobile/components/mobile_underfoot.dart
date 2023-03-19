import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/settings_service.dart';

/// Underfoot widget at the bottom of app on mobile platforms.
///
/// We use this because on old Android versions or when some users may use that
/// three bottom navigation virtual buttons (back, home and recent task page),
/// and the windowTranslucentNavigation property in styles.xml will make app
/// hovered by navigation bar.
/// Also even users don't use that navigation buttons there still some "sink"
/// behind navigation bar.
/// Use this Widget to make bottom "higher" to avoid hover.
class MobileUnderfoot extends StatelessWidget {
  /// const Constructor.
  const MobileUnderfoot({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => SizedBox(
          height: Get.find<SettingsService>().appBottomHeight.value,
        ),
      );
}
