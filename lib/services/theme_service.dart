import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/themes/app_themes.dart';

class ThemeService extends GetxService {
  final _usingDarkTheme = Get.isDarkMode.obs;

  void changeThemeModel() {
    _usingDarkTheme.value = !_usingDarkTheme.value;
    Get.changeTheme(_usingDarkTheme.value ? MPaxTheme.dark : MPaxTheme.light);
  }

  ThemeData getTheme() {
    // TODO: If set to follow system theme, get system theme.
    final systemTheme = SchedulerBinding.instance.window.platformBrightness;

    // TODO: If not set to follow system theme, get theme in configure.
    final usingDarkTheme = _usingDarkTheme.value;
    if (usingDarkTheme) {
      return MPaxTheme.dark;
    } else {
      return MPaxTheme.light;
    }
  }

  Future<ThemeService> init() async {
    // Load from config.
    return this;
  }
}
