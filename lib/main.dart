import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/themes/app_themes.dart';
import 'package:mpax_flutter/utils/platform.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:simple_audio/simple_audio.dart';
import 'package:taglib_ffi/taglib_ffi.dart' as taglib;
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MetadataGod.initialize();

  await taglib.initialize(isolateCount: 8);

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

  runApp(const MPaxApp());
}

/// App class.
class MPaxApp extends StatelessWidget {
  /// Constructor.
  const MPaxApp({super.key});

  @override
  Widget build(BuildContext context) => ProviderScope(
        child: ResponsiveBreakpoints.builder(
            child: MaterialApp.router(
              title: 'MPax',
              theme: AppTheme.flexLight,
              darkTheme: AppTheme.flexDark,
              routerConfig: appRoute,
              builder: (context, child) => Scaffold(body: child),
            ),
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 900, end: 900, name: 'EXPAND_SIDE_PANEL'),
              const Breakpoint(start: 1921, end: double.infinity, name: '4k'),
            ]),
      );
}
