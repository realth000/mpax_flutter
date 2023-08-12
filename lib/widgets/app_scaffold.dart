import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/widgets/app_navigation_widget.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

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
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle ?? _defaultAppBarTitle),
          actions: appBarActionsBuilder?.call(context, ref),
        ),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP))
              const AppNavigationRail(),
            Expanded(child: body),
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
