import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitleText extends StatelessWidget {
  const TitleText({required this.title, required this.level, super.key});

  final String title;
  final int level;

  static const List<TextStyle> styleList = <TextStyle>[
    TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    ),
    TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: styleList[level],
    );
  }
}

class ListTileLeading extends StatelessWidget {
  const ListTileLeading({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [child],
    );
  }
}

class ModalDialog extends StatelessWidget {
  const ModalDialog(
      {required this.child, this.showScrollbar = true, super.key});

  final Widget child;
  final bool showScrollbar;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Get.width / 3 * 2,
          maxHeight: Get.height / 3 * 2,
        ),
        child: showScrollbar
            ? Scrollbar(
                child: SingleChildScrollView(
                  child: child,
                ),
              )
            : SingleChildScrollView(
                child: child,
              ),
      ),
    );
  }
}
