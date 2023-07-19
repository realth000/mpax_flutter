import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.appBarTitle,
  });

  static const _defaultAppBarTitle = 'MPax';

  final String? appBarTitle;

  final Widget? body;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle ?? _defaultAppBarTitle),
        ),
        body: body,
      );
}
