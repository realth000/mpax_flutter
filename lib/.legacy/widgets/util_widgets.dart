import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Title header text widget.
class TitleText extends StatelessWidget {
  /// Constructor.
  const TitleText({required this.title, required this.level, super.key});

  /// Title text.
  final String title;

  /// Title level.
  final int level;

  /// Define styles.
  static const List<TextStyle> styleList = <TextStyle>[
    TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
  ];

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: styleList[level],
      );
}

/// Center placed item for [ListTile].
class ListTileLeading extends StatelessWidget {
  /// Constructor.
  const ListTileLeading({required this.child, super.key});

  /// Widget tot show.
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      );
}

/// Show a modal dialog.
class ModalDialog extends StatelessWidget {
  /// Constructor.
  const ModalDialog({
    required this.child,
    this.showScrollbar = true,
    super.key,
  });

  /// Widget to show.
  final Widget child;

  /// Whether show scroll bar, if the [child] is not high, better to set false.
  final bool showScrollbar;

  @override
  Widget build(BuildContext context) => Dialog(
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
