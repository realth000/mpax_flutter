import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Bar items in navigation bar.
class NavigationBarItem {
  /// Constructor.
  NavigationBarItem({required this.icon, required this.label});

  /// Bar item icon.
  final Icon icon;

  /// Bar item title text.
  final String label;
}

/// Controller for desktop navigation bar.
class NavigationBarController extends GetxController {
  final _barItems = <NavigationBarItem>[
    NavigationBarItem(
      icon: const Icon(Icons.library_music),
      label: 'Library'.tr,
    ),
    NavigationBarItem(
      icon: const Icon(Icons.queue_music),
      label: 'Playlist'.tr,
    ),
    NavigationBarItem(
      icon: const Icon(Icons.audiotrack),
      label: 'Music'.tr,
    ),
    NavigationBarItem(
      icon: const Icon(Icons.find_in_page),
      label: 'Scan'.tr,
    ),
    NavigationBarItem(
      icon: const Icon(Icons.settings),
      label: 'Settings'.tr,
    ),
    NavigationBarItem(
      icon: const Icon(Icons.info),
      label: 'About'.tr,
    ),
  ];

  /// Get bar items to generate navigation bar.
  List<NavigationBarItem> get barItems => _barItems;
}
