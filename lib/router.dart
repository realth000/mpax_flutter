import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/app_scaffold.dart';
import 'package:mpax_flutter/screens/welcome.dart';

class AppRoute {
  static const String welcome = '/';
  static const String mediaLibrary = '/library';
  static const String about = '/about';
}

final appRouter = GoRouter(routes: [
  AppRouter(path: AppRoute.welcome, builder: (state) => const WelcomePage()),
]);

class AppRouter extends GoRoute {
  AppRouter({
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

  static AppScaffold _buildScaffold(
    GoRouterState state,
    Widget Function(GoRouterState state) builder, {
    String? appBarTitle,
  }) {
    if (state.extra != null && state.extra is Map<String, String>) {
      final extra = state.extra as Map<String, String>;
      return AppScaffold(
        body: builder(state),
        appBarTitle: extra['appBarTitle'] ?? appBarTitle,
      );
    } else {
      return AppScaffold(
        body: builder(state),
        appBarTitle: appBarTitle,
      );
    }
  }
}
