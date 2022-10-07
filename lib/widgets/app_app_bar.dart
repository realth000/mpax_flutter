import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// App bar.
class MPaxAppBar extends StatelessWidget with PreferredSizeWidget {
  /// Constructor.
  MPaxAppBar({required this.title, this.actions = const <Widget>[], super.key});

  /// App bar title.
  final String title;

  /// App bar actions (top right).
  late final List<Widget> actions;

  // String leadingRouteName = "";

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(title.tr),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: actions,
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
