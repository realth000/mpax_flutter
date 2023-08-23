import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/settings_model.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';

class AppearancePage extends ConsumerStatefulWidget {
  const AppearancePage({super.key});

  static const appThemeList = <String>[
    appThemeLight,
    appThemeSystem,
    appThemeDark
  ];

  @override
  ConsumerState<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends ConsumerState<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Theme mode'),
              subtitle: Text('Light/Follow System/Dark'),
              trailing: ToggleButtons(
                isSelected: [
                  ref.watch(appStateProvider).appTheme == appThemeLight,
                  ref.watch(appStateProvider).appTheme == appThemeSystem,
                  ref.watch(appStateProvider).appTheme == appThemeDark,
                ],
                children: const [
                  Icon(Icons.light_mode),
                  Icon(Icons.auto_mode),
                  Icon(Icons.dark_mode),
                ],
                onPressed: (index) async {
                  ref
                      .read(appStateProvider.notifier)
                      .setAppTheme(AppearancePage.appThemeList[index]);
                  await ref
                      .read(appSettingsProvider.notifier)
                      .setAppTheme(AppearancePage.appThemeList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
