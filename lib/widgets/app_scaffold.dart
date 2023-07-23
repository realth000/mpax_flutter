import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/widgets/app_navigation_widget.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class AppScaffold extends ConsumerWidget {
  const AppScaffold({
    required this.body,
    super.key,
    this.appBarTitle,
  });

  static const _defaultAppBarTitle = 'MPax';

  final String? appBarTitle;

  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle ?? _defaultAppBarTitle),
      ),
      body: Row(
        children: [
          if (ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP))
            const AppNavigationRail(),
          body,
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ResponsiveBreakpoints.of(context).smallerThan(DESKTOP))
            AppMobilePlayer(),
          AppNavigationBar(),
        ],
      ));
}
