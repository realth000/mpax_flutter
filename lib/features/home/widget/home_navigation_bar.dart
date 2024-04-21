import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/home_cubit.dart';

/// Navigation bar or rail of the home page.
///
/// Root page.
class HomeNavigationBar extends StatefulWidget {
  /// Constructor.
  const HomeNavigationBar({super.key});

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final barItems = buildBarItems(context);

    return NavigationBar(
      destinations: barItems
          .map(
            (e) => NavigationDestination(
              icon: e.icon,
              selectedIcon: e.selectedIcon,
              label: e.label,
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
