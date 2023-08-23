import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mpax_flutter/models/settings_model.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/themes/app_themes.dart';
import 'package:mpax_flutter/utils/platform.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:simple_audio/simple_audio.dart';
import 'package:taglib_ffi/taglib_ffi.dart' as taglib;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (isMobile) {
    await checkPermissions();
  }

  await taglib.initialize();
  MetadataGod.initialize();

  await initializeDatabase();
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
  if (isDesktop) {
    // For hot restart.
    await windowManager.ensureInitialized();
  }

  // Load init data when start.
  await initSettings();

  runApp(ProviderScope(
      child: ResponsiveBreakpoints.builder(
    child: const MPaxApp(),
    breakpoints: const [
      Breakpoint(start: 0, end: 450, name: MOBILE),
      Breakpoint(start: 451, end: 800, name: TABLET),
      Breakpoint(start: 801, end: 1920, name: DESKTOP),
      Breakpoint(start: 900, end: 900, name: 'EXPAND_SIDE_PANEL'),
      Breakpoint(start: 1921, end: double.infinity, name: '4k'),
    ],
  )));
}

/// App class.
class MPaxApp extends ConsumerWidget {
  /// Constructor.
  const MPaxApp({super.key});

  static const _themeList = <String, ThemeMode>{
    appThemeLight: ThemeMode.light,
    appThemeSystem: ThemeMode.system,
    appThemeDark: ThemeMode.dark
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        title: 'MPax',
        theme: AppTheme.flexLight,
        darkTheme: AppTheme.flexDark,
        themeMode: _themeList[ref.watch(appStateProvider).appTheme],
        routerConfig: appRoute,
        builder: (context, child) => Scaffold(body: child),
      );
}

Future<void> checkPermissions() async {
  if (!await Permission.audio.isGranted &&
      !await Permission.audio.request().isGranted) {
    await Fluttertoast.showToast(
        msg: 'Permissions not granted, some features may not work');
  }
}
