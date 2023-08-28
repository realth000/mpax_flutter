import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/screens/media_library_page.dart';
import 'package:mpax_flutter/screens/playlist.dart';
import 'package:mpax_flutter/screens/playlist_detail.dart';
import 'package:mpax_flutter/screens/settings/about_page.dart';
import 'package:mpax_flutter/screens/settings/appearance_page.dart';
import 'package:mpax_flutter/screens/settings/scan_page.dart';
import 'package:mpax_flutter/screens/settings/settings_page.dart';
import 'package:mpax_flutter/screens/welcome.dart';
import 'package:mpax_flutter/widgets/app_scaffold.dart';

typedef AppBarActionsBuilder = List<Widget>? Function(
    BuildContext context, WidgetRef ref)?;

class ScreenPaths {
  static const String welcome = '/';
  static const String mediaLibrary = '/library';
  static const String playlist = '/playlist';
  static const String settings = '/settings';
  static const String scan = '/settings/scan';
  static const String appearance = '/settings/appearance';
  static const String about = '/settings/about';
}

final appRoute = GoRouter(routes: [
  AppRoute(
    path: ScreenPaths.welcome,
    builder: (state) => const WelcomePage(),
  ),
  AppRoute(
    path: ScreenPaths.mediaLibrary,
    builder: (state) => const MediaLibraryPage(),
  ),
  AppRoute(
    path: ScreenPaths.playlist,
    builder: (state) => const PlaylistPage(),
    appBarActionsBuilder: playlistPageActionsBuilder,
  ),
  AppRoute(
    path: '${ScreenPaths.playlist}/:playlistId',
    builder: (state) => PlaylistDetailPage(
      routerState: state,
    ),
  ),
  AppRoute(
    path: ScreenPaths.settings,
    builder: (state) => const SettingsPage(),
  ),
  AppRoute(
    path: ScreenPaths.scan,
    builder: (state) => const ScanPage(),
  ),
  AppRoute(
    path: ScreenPaths.appearance,
    builder: (state) => const AppearancePage(),
  ),
  AppRoute(
    path: ScreenPaths.about,
    builder: (state) => const AboutPage(),
  ),
]);

class AppRoute extends GoRoute {
  AppRoute({
    required super.path,
    required Widget Function(GoRouterState state) builder,
    AppBarActionsBuilder appBarActionsBuilder,
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
              appBarActionsBuilder,
              appBarTitle,
            ),
          ),
        );

  static Widget _buildScaffold(
    GoRouterState state,
    Widget Function(GoRouterState state) builder,
    AppBarActionsBuilder appBarActionsBuilder,
    String? appBarTitle,
  ) {
    if (state.path == ScreenPaths.welcome) {
      return builder(state);
    }
    if (state.extra != null && state.extra is Map<String, dynamic>) {
      final extra = state.extra as Map<String, dynamic>;
      return AppScaffold(
        appBarActionsBuilder: appBarActionsBuilder,
        body: SafeArea(
          child: builder(state),
        ),
        appBarTitle: extra['appBarTitle'] is String
            ? extra['appBarTitle'] as String
            : appBarTitle,
      );
    } else {
      return AppScaffold(
        appBarActionsBuilder: appBarActionsBuilder,
        body: SafeArea(
          child: builder(state),
        ),
        appBarTitle: appBarTitle,
      );
    }
  }
}
