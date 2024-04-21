import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../widget/home_navigation_bar.dart';

/// Root page of the app.
///
/// Wrap navigation bar and player around [child] widget.
class HomePage extends StatelessWidget {
  /// Constructor.
  const HomePage({
    required this.showNavigationBar,
    required this.child,
    super.key,
  });

  /// Control to show the app level navigation bar or not.
  ///
  /// Only show in top pages.
  final bool showNavigationBar;

  /// Content widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: child,
            bottomNavigationBar:
                showNavigationBar ? const HomeNavigationBar() : null,
          );
        },
      ),
    );
  }
}
