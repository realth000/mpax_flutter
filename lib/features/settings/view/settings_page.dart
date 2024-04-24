import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/strings.g.dart';
import '../../../widgets/section_list_tile.dart';
import '../../../widgets/section_title_text.dart';
import '../bloc/settings_bloc.dart';

/// Page to show app settings.
final class SettingsPage extends StatefulWidget {
  /// Constructor.
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/// State of [SettingsPage].
final class _SettingsPageState extends State<SettingsPage> {
  final scrollController = ScrollController();

  List<Widget> _buildAppearanceSection(
    BuildContext context,
    SettingsState state,
  ) {
    final tr = context.t.settingsPage;
    final themeMode = state.settingsModel.themeMode;
    final settingsLocale = state.settingsModel.locale;
    final locale = AppLocale.values
        .firstWhereOrNull((x) => x.languageTag == settingsLocale);
    final localeName = locale == null
        ? tr.appearance.languages.followSystem
        : context.t.locale;

    return [
      SectionTitleText(tr.title),
      SectionListTile(
        leading: const Icon(Icons.contrast_outlined),
        title: Text(tr.appearance.themeMode.title),
        subtitle: Text(
          <String>[
            context.t.settingsPage.appearance.themeMode.system,
            context.t.settingsPage.appearance.themeMode.light,
            context.t.settingsPage.appearance.themeMode.dark,
          ][themeMode],
        ),
        trailing: ToggleButtons(
          isSelected: [
            themeMode == ThemeMode.light.index,
            themeMode == ThemeMode.system.index,
            themeMode == ThemeMode.dark.index,
          ],
          children: const [
            Icon(Icons.light_mode_outlined),
            Icon(Icons.auto_mode_outlined),
            Icon(Icons.dark_mode_outlined),
          ],
          onPressed: (index) async {
            // Default: ThemeData.system.
            var themeIndex = 0;
            switch (index) {
              case 0:
                // Default: ThemeData.light.
                themeIndex = 1;
              case 1:
                // Default: ThemeData.system.
                themeIndex = 0;
              case 2:
                // Default: ThemeData.dark.
                themeIndex = 2;
            }
            // Effect immediately.
            // context.read<ThemeCubit>().setThemeModeIndex(themeIndex);
            // Save to settings.
            context
                .read<SettingsBloc>()
                .add(SettingsChangeThemeModeRequested(themeIndex));
          },
        ),
      ),
    ];
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settingsPage;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(tr.title)),
          body: ListView(
            controller: scrollController,
            children: [
              ..._buildAppearanceSection(context, state),
            ],
          ),
        );
      },
    );
  }
}
