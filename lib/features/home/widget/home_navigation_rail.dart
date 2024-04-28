import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/home_cubit.dart';

/// Navigation rail used on wide screens.
final class HomeNavigationRail extends StatefulWidget {
  /// Constructor.
  const HomeNavigationRail({super.key});

  @override
  State<HomeNavigationRail> createState() => _HomeNavigationRailState();
}

final class _HomeNavigationRailState extends State<HomeNavigationRail> {
  @override
  Widget build(BuildContext context) {
    final barItems = buildBarItems(context);
    return NavigationRail(
      destinations: barItems
          .map(
            (e) => NavigationRailDestination(
              icon: e.icon,
              selectedIcon: e.selectedIcon,
              label: Text(e.label),
            ),
          )
          .toList(),
      selectedIndex:
          context.select<HomeCubit, HomeTab>((cubit) => cubit.state.tab).index,
      onDestinationSelected: (index) {
        context.read<HomeCubit>().setTab(barItems[index].tab);
        context.goNamed(barItems[index].targetPath);
      },
    );
  }
}
