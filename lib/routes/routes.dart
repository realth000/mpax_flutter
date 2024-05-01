import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mpax_flutter/features/album/view/album_page.dart';
import 'package:mpax_flutter/features/artist/view/artist_page.dart';
import 'package:mpax_flutter/features/home/view/home_page.dart';
import 'package:mpax_flutter/features/music_library/view/music_library_page.dart';
import 'package:mpax_flutter/features/playlist/view/playlist_page.dart';
import 'package:mpax_flutter/features/settings/view/settings_page.dart';
import 'package:mpax_flutter/routes/screen_paths.dart';

final _rootRouteKey = GlobalKey<NavigatorState>();
final _shellRouteKey = GlobalKey<NavigatorState>();

/// App router config.
///
/// All app routes are defined here.
final routerConfig = GoRouter(
  navigatorKey: _rootRouteKey,
  initialLocation: ScreenPaths.library,
  routes: [
    ShellRoute(
      navigatorKey: _shellRouteKey,
      builder: (context, router, navigator) => HomePage(
        showNavigationBar: true,
        child: navigator,
      ),
      routes: [
        _AppRoute(
          path: ScreenPaths.library,
          parentNavigatorKey: _shellRouteKey,
          builder: (_) => const MusicLibraryPage(),
        ),
        _AppRoute(
          path: ScreenPaths.album,
          parentNavigatorKey: _shellRouteKey,
          builder: (_) => const AlbumPage(),
        ),
        _AppRoute(
          path: ScreenPaths.artist,
          parentNavigatorKey: _shellRouteKey,
          builder: (_) => const ArtistPage(),
        ),
        _AppRoute(
          path: ScreenPaths.playlist,
          parentNavigatorKey: _shellRouteKey,
          builder: (_) => const PlaylistPage(),
        ),
        _AppRoute(
          path: ScreenPaths.settings,
          parentNavigatorKey: _shellRouteKey,
          builder: (_) => const SettingsPage(),
        ),
      ],
    ),
  ],
);

/// Refer from wondrous app.
/// Custom router declaration.
class _AppRoute extends GoRoute {
  /// Constructor.
  _AppRoute({
    required super.path,
    required Widget Function(GoRouterState s) builder,
    List<GoRoute> routes = const [],
    super.parentNavigatorKey,
    //super.redirect,
  }) : super(
          name: path,
          routes: routes,
          pageBuilder: (context, state) => MaterialPage<void>(
            name: path,
            arguments: state.pathParameters,
            child: builder(state),
          ),
        );
}
