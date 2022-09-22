import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MPaxAppBar extends StatelessWidget with PreferredSizeWidget {
  MPaxAppBar({required this.title, this.actions = const <Widget>[], super.key});

  final String title;
  late final List<Widget> actions;

  // String leadingRouteName = "";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title.tr),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
