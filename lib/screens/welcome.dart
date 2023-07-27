import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/router.dart';
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
    return Center(
      child: SizedBox(
        width: 200,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome to MPax',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                context.goNamed(
                  ScreenPaths.scan,
                  extra: <String, String>{'appBarTitle': 'Scan'},
                );
              },
              child: Text('Scan music'),
            ),
          ],
        ),
      ),
    );
  }
}
