import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpax_flutter/features/home/cubit/home_cubit.dart';
import 'package:mpax_flutter/features/home/widget/home_navigation_bar.dart';
import 'package:mpax_flutter/features/home/widget/home_navigation_rail.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
          if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
            return Scaffold(
              body: showNavigationBar
                  ? Row(
                      children: [
                        const HomeNavigationRail(),
                        Expanded(child: child),
                      ],
                    )
                  : child,
            );
          }
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
