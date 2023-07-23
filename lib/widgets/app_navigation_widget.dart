import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

/// Bar items in navigation bar.
class NavigationBarItem {
  /// Constructor.
  NavigationBarItem({required this.icon, required this.label});

  /// Bar item icon.
  final Icon icon;

  /// Bar item title text.
  final String label;
}

final _barItems = <NavigationBarItem>[
  NavigationBarItem(
    icon: const Icon(Icons.library_music),
    label: 'Library',
  ),
  NavigationBarItem(
    icon: const Icon(Icons.queue_music),
    label: 'Playlist',
  ),
  // NavigationBarItem(
  //   icon: const Icon(Icons.audiotrack),
  //   label: 'Music',
  // ),
  NavigationBarItem(
    icon: const Icon(Icons.settings),
    label: 'Settings',
  ),
];

class AppNavigationRail extends ConsumerWidget {
  const AppNavigationRail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NavigationRail(
      extended: ResponsiveBreakpoints.of(context)
          .largerOrEqualTo('EXPAND_SIDE_PANEL'),
      destinations: _barItems
          .map(
            (e) => NavigationRailDestination(
              icon: e.icon,
              label: Text(e.label),
            ),
          )
          .toList(),
      selectedIndex: ref.watch(appStateProvider).screenIndex,
      onDestinationSelected: (index) {
        ref.read(appStateProvider.notifier).setScreenIndex(index);
      },
      labelType: NavigationRailLabelType.none,
    );
  }
}

class AppNavigationBar extends ConsumerWidget {
  const AppNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => NavigationBar(
        destinations: _barItems
            .map((e) => NavigationDestination(icon: e.icon, label: e.label))
            .toList(),
        selectedIndex: ref.watch(appStateProvider).screenIndex,
        onDestinationSelected: (index) {
          ref.read(appStateProvider.notifier).setScreenIndex(index);
        },
      );
}
