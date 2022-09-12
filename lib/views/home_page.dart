import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/routes/app_pages.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';

import '../widgets/app_player_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: "Welcome".tr,
      ),
      drawer: const MPaxDrawer(),
      bottomNavigationBar: MPaxPlayerWidget(),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Column(
            children: <Widget>[
              Text(
                "Welcome to MPax".tr,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(MPaxRoutes.scan);
                },
                child: Text("Scan music".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
