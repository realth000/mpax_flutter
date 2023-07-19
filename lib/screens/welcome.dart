import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Text('Welcome!'),
        ),
      );
}
