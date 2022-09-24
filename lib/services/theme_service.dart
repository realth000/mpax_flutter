import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/themes/app_themes.dart';

enum MPaxThemeMode {
  auto,
  dark,
  light,
}

class ThemeService extends GetxService {
  final _configService = Get.find<ConfigService>();

  // Theme settings.
  bool useDarkTheme = Get.isDarkMode;
  bool followSystemDarkMode = true;

  void changeThemeMode(MPaxThemeMode mode) {
    if (mode == MPaxThemeMode.auto) {
      final systemTheme = SchedulerBinding.instance.window.platformBrightness;
      followSystemDarkMode = true;
      if (systemTheme == Brightness.dark) {
        Get.changeTheme(MPaxTheme.dark);
      } else {
        Get.changeTheme(MPaxTheme.light);
      }
    } else if (mode == MPaxThemeMode.dark) {
      followSystemDarkMode = false;
      useDarkTheme = true;
      Get.changeTheme(MPaxTheme.dark);
    } else if (mode == MPaxThemeMode.light) {
      followSystemDarkMode = false;
      useDarkTheme = false;
      Get.changeTheme(MPaxTheme.light);
    }
    saveThemeConfig();
  }

  ThemeData getTheme() {
    if (followSystemDarkMode) {
      final systemTheme = SchedulerBinding.instance.window.platformBrightness;
      if (systemTheme == Brightness.dark) {
        return MPaxTheme.dark;
      }
      return MPaxTheme.light;
    }
    if (useDarkTheme) {
      return MPaxTheme.dark;
    } else {
      return MPaxTheme.light;
    }
  }

  void saveThemeConfig() {
    _configService.saveBool('FollowSystemDarkMode', followSystemDarkMode);
    _configService.saveBool('UseDarkMode', useDarkTheme);
  }

  Future<ThemeService> init() async {
    // Load from config.
    followSystemDarkMode =
        _configService.getBool('FollowSystemDarkMode') ?? true;
    useDarkTheme = _configService.getBool('UseDarkMode') ?? false;
    return this;
  }
}
