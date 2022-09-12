import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/routes/app_pages.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/translations/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MPaxApp());
}

class Controller extends GetxController {}

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

Future<void> initServices() async {
  await Get.putAsync(() async => await ConfigService());
  await Get.putAsync(() async => await MediaLibraryService());
  await Get.putAsync(() async => await PlayerService());
}
