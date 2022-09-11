import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text("Scan on device".tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
