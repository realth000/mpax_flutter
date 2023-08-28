import 'package:flutter/material.dart';
import 'package:mpax_flutter/widgets/app_navigation_widget.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class RootScaffold extends StatelessWidget {
  const RootScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP))
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: const AppNavigationRail()),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar:
          (ResponsiveBreakpoints.of(context).smallerThan(DESKTOP))
              ? const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppMobilePlayer(),
                    AppNavigationBar(),
                  ],
                )
              : const AppDesktopPlayer(),
    );
  }
}
