import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/themes/app_themes.dart';
import 'package:mpax_flutter/utils/platform.dart';
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
        child: MaterialApp.router(
          title: 'MPax',
          theme: AppTheme.flexLight,
          darkTheme: AppTheme.flexDark,
          routerConfig: appRouter,
          builder: (context, child) => Scaffold(body: child),
        ),
      );
}
