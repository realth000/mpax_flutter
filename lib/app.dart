import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mpax_flutter/features/music_library/bloc/music_library_bloc.dart';
import 'package:mpax_flutter/features/settings/bloc/settings_bloc.dart';
import 'package:mpax_flutter/features/theme/cubit/theme_cubit.dart';
import 'package:mpax_flutter/i18n/strings.g.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/routes/routes.dart';
import 'package:mpax_flutter/themes/app_themes.dart';

/// App entry definition.
class App extends StatelessWidget {
  /// Constructor.
  const App({required this.themeMode, super.key});

  /// Initial theme mode loaded outside. For startup usage.
  ///
  /// Because the drift database only support asynchronous operations, it's
  /// better to get the theme mode index outside [App] where we can wait for
  /// futures.
  ///
  /// Without this initial value, [SettingsBloc] need to be registered globally
  /// and there is also a latency before applying all settings read from
  /// storage.
  final int themeMode;

  @override
  Widget build(BuildContext context) {
    logger.i('rebuild app');
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MusicLibraryBloc(sl(), sl())
            ..add(
              const MusicLibraryReloadRequested(),
            ),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(sl())..add(const SettingsLoadAll()),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(themeModeIndex: themeMode),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeState = context.watch<ThemeCubit>().state;
          final accentColor = themeState.accentColor;
          final lightTheme = AppTheme.makeLight(accentColor);
          final darkTheme = AppTheme.makeDark(accentColor);
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
    );
  }
}
