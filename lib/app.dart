import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'features/settings/bloc/settings_bloc.dart';
import 'features/theme/cubit/theme_cubit.dart';
import 'i18n/strings.g.dart';
import 'instance.dart';
import 'routes/routes.dart';
import 'themes/app_themes.dart';

/// App entry definition.
class App extends StatelessWidget {
  /// Constructor.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(sl())..add(const SettingsLoadAll()),
        )
      ],
      child: BlocListener<SettingsBloc, SettingsState>(
        listenWhen: (prev, curr) =>
            prev.settingsModel.themeMode != curr.settingsModel.themeMode,
        listener: (context, state) {
          context
              .read<ThemeCubit>()
              .setThemeModeIndex(state.settingsModel.themeMode);
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final themeState = context.watch<ThemeCubit>().state;
            final lightTheme = AppTheme.makeLight();
            final darkTheme = AppTheme.makeDark();
            final themeModeIndex = themeState.themeModeIndex;

            return MaterialApp.router(
              title: context.t.appName,
              routerConfig: routerConfig,
              locale: TranslationProvider.of(context).flutterLocale,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.values[themeModeIndex],
            );
          },
        ),
      ),
    );
  }
}
