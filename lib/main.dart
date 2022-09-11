import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'translations/translations.dart';

void main() {
  runApp(const MPaxApp());
}

class Controller extends GetxController {

}

class MPaxApp extends StatelessWidget {
  const MPaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MPaxTranslations(),
      locale: const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: MPaxPages.initialPage,
      getPages: MPaxPages.routes,
    );
  }
}
