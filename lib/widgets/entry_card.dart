import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/utils/platform.dart';

class EntryCard<T> extends ConsumerStatefulWidget {
  const EntryCard({
    this.cover,
    this.defaultCover = const Icon(Icons.launch),
    this.description = '',
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.popupMenuItemBuilder,
    this.popupMenuOnOpened,
    this.popupMenuOnSelected,
    this.popupMenuOnCanceled,
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

  /// Lite embedded [PopupMenuButton].
  final PopupMenuItemBuilder<T>? popupMenuItemBuilder;
  final VoidCallback? popupMenuOnOpened;
  final PopupMenuItemSelected<T>? popupMenuOnSelected;
  final PopupMenuCanceled? popupMenuOnCanceled;

  @override
  ConsumerState<EntryCard<T>> createState() => _EntryCardState<T>();
}

class _EntryCardState<T> extends ConsumerState<EntryCard<T>> {
  Offset offset = Offset.zero;

  Future<void> showEntryMenu(
    BuildContext context,
    PopupMenuItemBuilder<T> itemBuilder,
    VoidCallback? onOpened,
    PopupMenuItemSelected<T>? onSelected,
    PopupMenuCanceled? onCanceled,
  ) async {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          offset,
          ancestor: overlay,
        ),
        button.localToGlobal(
          offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
    final items = itemBuilder(context);

    onOpened?.call();
    if (items.isNotEmpty) {
      await showMenu<T?>(
        context: context,
        items: items,
        position: position,
      ).then<void>((newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          onCanceled?.call();
          return null;
        }
        onSelected?.call(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = SizedBox(
      child: Card(
        child: InkWell(
          onTap: widget.onTap,
          onLongPress: () async {
            widget.onLongPress?.call();
            if (widget.popupMenuItemBuilder != null && isMobile) {
              await showEntryMenu(
                context,
                widget.popupMenuItemBuilder!,
                widget.popupMenuOnOpened,
                widget.popupMenuOnSelected,
                widget.popupMenuOnCanceled,
              );
            }
          },
          onSecondaryTap: () async {
            widget.onSecondaryTap?.call();
            if (widget.popupMenuItemBuilder != null && isDesktop) {
              await showEntryMenu(
                context,
                widget.popupMenuItemBuilder!,
                widget.popupMenuOnOpened,
                widget.popupMenuOnSelected,
                widget.popupMenuOnCanceled,
              );
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                Expanded(
                  child: widget.cover ?? widget.defaultCover,
                ),
                Text(
                  widget.description,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.popupMenuItemBuilder != null) {
      return MouseRegion(
        onEnter: (e) {
          offset = e.localPosition;
        },
        onHover: (e) {
          offset = e.localPosition;
        },
        child: box,
      );
    } else {
      return box;
    }
  }
}
