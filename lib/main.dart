import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mpax_flutter/desktop/services/scaffold_service.dart';
import 'package:mpax_flutter/mobile/services/media_query_service.dart';
import 'package:mpax_flutter/routes/app_pages.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:mpax_flutter/services/locale_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/services/search_service.dart';
import 'package:mpax_flutter/services/settings_service.dart';
import 'package:mpax_flutter/services/theme_service.dart';
import 'package:mpax_flutter/themes/app_themes.dart';
import 'package:mpax_flutter/translations/translations.dart';
import 'package:simple_audio/simple_audio.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();
  await SimpleAudio.init(
    dbusName: 'kzs.th000.mpax_flutter',
    actions: [
      MediaControlAction.rewind,
      MediaControlAction.skipPrev,
      MediaControlAction.playPause,
      MediaControlAction.skipNext,
      MediaControlAction.fastForward,
    ],
    androidCompactActions: [1, 2, 3],
  );
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
    await Get.putAsync(() async => PlayerService().init());
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
