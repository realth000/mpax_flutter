import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:window_manager/window_manager.dart';

import '../routes/app_pages.dart';
import '../services/locale_service.dart';
import '../services/media_library_service.dart';
import '../services/metadata_service.dart';
import '../services/player_service.dart';
import '../services/settings_service.dart';
import '../services/theme_service.dart';
import '../themes/app_themes.dart';
import '../translations/translations.dart';
import 'desktop/services/scaffold_service.dart';
import 'mobile/services/media_query_service.dart';
import 'services/database_service.dart';
import 'services/search_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  if (GetPlatform.isDesktop) {
    // For hot restart.
    await windowManager.ensureInitialized();
  }
  await initServices();
  runApp(const MPaxApp());

  if (GetPlatform.isDesktop) {
    await initWindow();
  }
  // Load init data when start.
  await Get.find<PlayerService>().loadInitMedia();
}

/// App class.
class MPaxApp extends StatelessWidget {
  /// Constructor.
  const MPaxApp({super.key});

  String _initialRoute() {
    if (GetPlatform.isMobile) {
      if (GetPlatform.isAndroid) {
        return MPaxRoutes.library;
      }
      final mediaLibraryService = Get.find<MediaLibraryService>();
      return mediaLibraryService.allMusic.value.isEmpty
          ? MPaxRoutes.library
          : MPaxRoutes.home;
    } else {
      return MPaxDesktopRoutes.root;
    }
  }

  List<GetPage> _pages() {
    if (GetPlatform.isMobile) {
      return MPaxPages.mobileRoutes;
    } else {
      return MPaxPages.desktopRoutes;
    }
  }

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        translations: MPaxTranslations(),
        locale: Get.find<LocaleService>().getLocale(),
        fallbackLocale: LocaleService.fallbackLocale,
        initialRoute: _initialRoute(),
        getPages: _pages(),
        theme: MPaxTheme.flexLight,
        darkTheme: MPaxTheme.flexDark,
      );
}

/// Init all global services, call this before [runApp].
Future<void> initServices() async {
  if (GetPlatform.isDesktop) {
    await Get.putAsync(() async => ScaffoldService().init());
  }

  late final PlayerWrapper wrapper;
  if (GetPlatform.isMobile) {
    wrapper = await AudioService.init(
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
      builder: PlayerWrapper.new,
    );
  }
  // Use service.init() here to make sure service is init.
  await Get.putAsync(() async => SettingsService().init());
  await Get.putAsync(() async => DatabaseService().init());
  await Get.putAsync(() async => ThemeService().init());
  await Get.putAsync(() async => LocaleService().init());
  await Get.putAsync(() async => MetadataService().init());
  // First initialize [MediaQueryService] and then [MediaLibraryService].
  if (GetPlatform.isAndroid) {
    await Get.putAsync(() async => MediaQueryService().init());
  }
  await Get.putAsync(() async => MediaLibraryService().init());
  if (GetPlatform.isMobile) {
    await Get.putAsync(() async => PlayerService(wrapper: wrapper).init());
  } else {
    await Get.putAsync(() async => PlayerService().init());
  }
  await Get.putAsync(() async => SearchService().init());
}

/// Init app window settings.
Future<void> initWindow() async {
  final settingsService = Get.find<SettingsService>();

  final useSystemNativeTitleBar =
      settingsService.getBool('UseSystemNativeTitleBar') ?? false;

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      size: const Size(1024, 768),
      minimumSize: const Size(1024, 768),
      // center: true,
      skipTaskbar: false,
      title: 'MPax',
      titleBarStyle:
          useSystemNativeTitleBar ? TitleBarStyle.normal : TitleBarStyle.hidden,
    ),
  );
  if (!useSystemNativeTitleBar) {
    await windowManager.setAsFrameless();
  }
}
