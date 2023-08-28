import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/router.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.appBarTitle,
    this.appBarActionsBuilder,
  });

  static const _defaultAppBarTitle = 'MPax';

  final String? appBarTitle;

  final AppBarActionsBuilder appBarActionsBuilder;

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle ?? _defaultAppBarTitle),
        actions: appBarActionsBuilder?.call(context, ref),
      ),
      body: body,
    );
  }
}
