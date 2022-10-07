import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../routes/app_pages.dart';
import '../services/config_service.dart';
import '../services/locale_service.dart';
import '../services/media_library_service.dart';
import '../services/metadata_service.dart';
import '../services/player_service.dart';
import '../services/theme_service.dart';
import '../themes/app_themes.dart';
import '../translations/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await initServices();
  runApp(const MPaxApp());
}

/// App class.
class MPaxApp extends StatelessWidget {
  /// Constructor.
  const MPaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaLibraryService = Get.find<MediaLibraryService>();
    return GetMaterialApp(
      translations: MPaxTranslations(),
      locale: Get.find<LocaleService>().getLocale(),
      fallbackLocale: LocaleService.fallbackLocale,
      initialRoute: mediaLibraryService.content.isNotEmpty
          ? MPaxRoutes.library
          : MPaxRoutes.home,
      getPages: MPaxPages.routes,
      theme: MPaxTheme.flexLight,
      darkTheme: MPaxTheme.flexDark,
    );
  }
}

/// Init all global services, call this before [runApp].
Future<void> initServices() async {
  // Use service.init() here to make sure service is init.
  await Get.putAsync(() async => ConfigService().init());
  await Get.putAsync(() async => ThemeService().init());
  await Get.putAsync(() async => LocaleService().init());
  await Get.putAsync(() async => MetadataService().init());
  await Get.putAsync(() async => MediaLibraryService().init());
  await Get.putAsync(() async => PlayerService().init());
}
