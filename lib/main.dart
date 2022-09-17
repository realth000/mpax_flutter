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
    MediaLibraryService mediaLibraryService = Get.find<MediaLibraryService>();
    return GetMaterialApp(
      translations: MPaxTranslations(),
      locale: const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: mediaLibraryService.content.isNotEmpty
          ? MPaxRoutes.library
          : MPaxRoutes.home,
      getPages: MPaxPages.routes,
    );
  }
}

Future<void> initServices() async {
  // Use service.init() here to make sure service is init.
  await Get.putAsync(() async => await ConfigService().init());
  await Get.putAsync(() async => await MediaLibraryService().init());
  await Get.putAsync(() async => await PlayerService().init());
}
