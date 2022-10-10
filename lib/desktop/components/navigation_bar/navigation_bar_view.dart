import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/scaffold.service.dart';
import 'navigation_bar_controller.dart';

/// Navigation bar use for desktop.
class MPaxNavigationBar extends StatelessWidget {
  /// Constructor.
  MPaxNavigationBar({super.key});

  final _controller = Get.put(NavigationBarController());
  final _pageController = Get.find<ScaffoldService>();

  @override
  Widget build(BuildContext context) => Obx(
        () => NavigationRail(
          destinations: _controller.barItems
              .map(
                (e) => NavigationRailDestination(
                  icon: e.icon,
                  label: Text(e.label),
                ),
              )
              .toList(),
          selectedIndex: _pageController.currentIndex.value,
          onDestinationSelected: (index) {
            _pageController.currentIndex.value = index;
          },
          labelType: NavigationRailLabelType.selected,
        ),
      );
}
