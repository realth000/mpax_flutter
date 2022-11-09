import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mobile/components/mobile_underfoot.dart';
import '../routes/app_pages.dart';
import '../widgets/app_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_player_widget.dart';

/// Homepage, shows when first start or nothing in media library.
class HomePage extends StatelessWidget {
  /// Constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: 'Welcome'.tr,
        ),
        drawer: const MPaxDrawer(),
        body: Center(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: <Widget>[
                Text(
                  'Welcome to MPax'.tr,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Get.toNamed(MPaxRoutes.scan);
                  },
                  child: Text('Scan music'.tr),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
      );
}
