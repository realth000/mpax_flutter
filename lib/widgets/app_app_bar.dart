import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';

class MPaxAppBar extends StatelessWidget with PreferredSizeWidget {
  const MPaxAppBar({required this.title, super.key});

  final String title;

  // String leadingRouteName = "";

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$title'.tr),
      leading:  IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () { Scaffold.of(context).openDrawer(); },
      ),
      actions: <Widget>[],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
