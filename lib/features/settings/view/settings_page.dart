import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mpax_flutter/features/logging/enums/loglevel.dart';
import 'package:mpax_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:mpax_flutter/features/settings/widgets/select_accent_color_dialog.dart';
import 'package:mpax_flutter/features/settings/widgets/select_language_dialog.dart';
import 'package:mpax_flutter/features/settings/widgets/select_loglevel_dialog.dart';
import 'package:mpax_flutter/features/theme/cubit/theme_cubit.dart';
import 'package:mpax_flutter/i18n/strings.g.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/utils/show_dialog.dart';
import 'package:mpax_flutter/widgets/section_list_tile.dart';
import 'package:mpax_flutter/widgets/section_title_text.dart';

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
    final tr = context.t.settingsPage.appearance;
    final themeMode = state.settingsModel.themeMode;
    final settingsLocale = state.settingsModel.locale;
    final locale = AppLocale.values
        .firstWhereOrNull((x) => x.languageTag == settingsLocale);
    final localeName =
        locale == null ? tr.languages.followSystem : context.t.locale;
    final accentColorValue = state.settingsModel.accentColor;

    return [
      SectionTitleText(tr.title),

      /// Theme mode.
      SectionListTile(
        leading: const Icon(Icons.contrast_outlined),
        title: Text(tr.themeMode.title),
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
            context.read<ThemeCubit>().setThemeModeIndex(themeIndex);
            // Save to settings.
            context
                .read<SettingsBloc>()
                .add(SettingsChangeThemeModeRequested(themeIndex));
            logger.i('[settings] set theme mode to $themeIndex');
          },
        ),
      ),

      /// Languages
      SectionListTile(
        leading: const Icon(Icons.translate_outlined),
        title: Text(tr.languages.title),
        subtitle: Text(localeName),
        onTap: () async {
          final result = await _showSelectLanguageDialog(
            context,
            locale?.languageTag ?? '',
          );
          if (result == null) {
            return;
          }
          if (result.$2) {
            LocaleSettings.useDeviceLocale();
            if (!context.mounted) {
              return;
            }
            context
                .read<SettingsBloc>()
                .add(const SettingsChangeLocaleRequested(''));
            logger.i('[settings] set language to follow system');
            return;
          }
          if (!context.mounted) {
            return;
          }
          LocaleSettings.setLocale(result.$1!);
          context
              .read<SettingsBloc>()
              .add(SettingsChangeLocaleRequested(result.$1!.languageTag));
          logger.i('[settings] set language to ${result.$1!.languageTag}');
        },
      ),

      /// Accent color
      SectionListTile(
        leading: const Icon(Icons.palette_outlined),
        title: Text(tr.colorScheme.title),
        onTap: () async {
          final colorValue = await _showSelectAccentColorDialog(
            context,
            accentColorValue,
          );
          if (colorValue == null || !context.mounted) {
            return;
          }
          context.read<ThemeCubit>().setAccentColor(Color(colorValue));
          context
              .read<SettingsBloc>()
              .add(SettingsChangeAccentColorRequested(Color(colorValue)));
        },
      ),
    ];
  }

  /// Show a dialog to let user select locale.
  ///
  /// * Return null if user canceled the selection.
  /// * Return (null, true) if user chose to use system locale.
  /// * Return (locale, false) if user chose to use specified locale.
  Future<(AppLocale?, bool)?> _showSelectLanguageDialog(
    BuildContext context,
    String currentLocale,
  ) async {
    return showDialog<(AppLocale?, bool)>(
      context: context,
      builder: (context) => SelectLanguageDialog(currentLocale),
    );
  }

  Future<int?> _showSelectAccentColorDialog(
    BuildContext context,
    int colorValue,
  ) async {
    return showDialog<int>(
      context: context,
      builder: (_) => SelectAccentColorDialog(
        currentColorValue: colorValue,
        blocContext: context,
      ),
    );
  }

  List<Widget> _buildDebugSection(
    BuildContext context,
    SettingsState state,
  ) {
    final tr = context.t.settingsPage.debug;
    final loglevel = state.settingsModel.loglevel;

    return [
      SectionTitleText(tr.title),
      SectionListTile(
        leading: const Icon(Symbols.contract),
        title: Text(tr.loglevel.title),
        subtitle: Text(loglevel.tr(context)),
        onTap: () async {
          final level = await _showSelectLoglevelDialog(context, loglevel);
          if (level == null || !context.mounted) {
            return;
          }
          context
              .read<SettingsBloc>()
              .add(SettingsChangeLoglevelRequested(level));
          logger.i('[settings] set loglevel to $level');
          await showMessageSingleButtonDialog(
            context: context,
            title: tr.title,
            message: context.t.general.applyAfterRestart,
          );
        },
      ),
    ];
  }

  Future<Loglevel?> _showSelectLoglevelDialog(
    BuildContext context,
    Loglevel loglevel,
  ) async {
    return showDialog<Loglevel>(
      context: context,
      builder: (_) => SelectLoglevelDialog(loglevel),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //BlocProvider(
  //create: (context) => SettingsBloc(sl())..add(const SettingsLoadAll()),
  //)

  @override
  Widget build(BuildContext context) {
    final tr = context.t.settingsPage;
    return BlocProvider(
      create: (context) => SettingsBloc(sl())..add(const SettingsLoadAll()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: Text(tr.title)),
            body: ListView(
              controller: scrollController,
              children: [
                ..._buildAppearanceSection(context, state),
                ..._buildDebugSection(context, state),
              ],
            ),
          );
        },
      ),
    );
  }
}
