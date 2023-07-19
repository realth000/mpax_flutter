import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final Color color;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      color = Colors.red;
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      color = Colors.green;
    } else {
      color = Colors.yellow;
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Text(
          'Welcome!',
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
