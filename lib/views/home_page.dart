import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        bottomNavigationBar: const MPaxPlayerWidget(),
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
      );
}
