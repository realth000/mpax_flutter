import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EntryCard extends ConsumerWidget {
  const EntryCard({
    this.cover,
    this.defaultCover = const Icon(Icons.launch),
    this.description = '',
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    super.key,
  });

  /// Cover image on this entry widget.
  /// If is null, show [defaultCover] instead.
  final Image? cover;

  /// When [cover] is null, show this default widget.
  final Widget defaultCover;

  /// Text description of this entry, under [cover], bottom of this widget.
  final String description;

  /// Something to do when user pressed this widget.
  final VoidCallback? onTap;

  /// Something to do when user long pressed this widget (on mobile platforms)
  /// or right click on this widget (on desktop platforms).
  final VoidCallback? onLongPress;
  final VoidCallback? onSecondaryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Card(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          onSecondaryTap: onSecondaryTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                Expanded(
                  child: cover ?? defaultCover,
                ),
                Text(
                  description,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
