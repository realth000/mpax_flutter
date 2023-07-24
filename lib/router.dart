import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/screens/media_library_page.dart';
import 'package:mpax_flutter/screens/scan_page.dart';
import 'package:mpax_flutter/screens/settings_page.dart';
import 'package:mpax_flutter/screens/welcome.dart';
import 'package:mpax_flutter/widgets/app_scaffold.dart';

class ScreenPaths {
  static const String welcome = '/';
  static const String mediaLibrary = '/library';
  static const String settings = '/settings';
  static const String scan = '/settings/scan';
}

final appRoute = GoRouter(routes: [
  AppRoute(
    path: ScreenPaths.welcome,
    builder: (state) => const WelcomePage(),
  ),
  AppRoute(
      path: ScreenPaths.mediaLibrary,
      builder: (state) => const MediaLibraryPage()),
  AppRoute(
    path: ScreenPaths.settings,
    builder: (state) => const SettingsPage(),
  ),
  AppRoute(
    path: ScreenPaths.scan,
    builder: (state) => const ScanPage(),
  ),
]);

class AppRoute extends GoRoute {
  AppRoute({
    required super.path,
    required Widget Function(GoRouterState state) builder,
    List<GoRoute> routes = const [],
    String? appBarTitle,
    super.redirect,
  }) : super(
          name: path,
          routes: routes,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: path,
            arguments: state.pathParameters,
            child: _buildScaffold(
              state,
              builder,
              appBarTitle: appBarTitle,
            ),
          ),
        );

  static Widget _buildScaffold(
    GoRouterState state,
    Widget Function(GoRouterState state) builder, {
    String? appBarTitle,
  }) {
    if (state.path == ScreenPaths.welcome) {
      return builder(state);
    }
    if (state.extra != null && state.extra is Map<String, String>) {
      final extra = state.extra as Map<String, String>;
      return AppScaffold(
        body: SafeArea(
          child: builder(state),
        ),
        appBarTitle: extra['appBarTitle'] ?? appBarTitle,
      );
    } else {
      return AppScaffold(
        body: SafeArea(
          child: builder(state),
        ),
        appBarTitle: appBarTitle,
      );
    }
  }
}
