import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/routes/screen_paths.dart';

final _rootRouteKey = GlobalKey<NavigatorState>();
final _shellRouteKey = GlobalKey<NavigatorState>();

final routerConfig = GoRouter(
  navigatorKey: _rootRouteKey,
  initialLocation: ScreenPaths.musicLibrary,
  routes: [
    ShellRoute(
      navigatorKey: _shellRouteKey,
      routes: [],
    ),
  ],
);
