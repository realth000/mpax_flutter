import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/themes/app_themes.dart';

class ThemeService extends GetxService {
  final _configService = Get.find<ConfigService>();

  // Theme settings.
  final useDarkTheme = Get.isDarkMode.obs;
  bool followSystemDarkMode = true;

  void changeThemeModel() {
    useDarkTheme.value = !useDarkTheme.value;
    Get.changeTheme(useDarkTheme.value ? MPaxTheme.dark : MPaxTheme.light);
  }

  ThemeData getTheme() {
    if (followSystemDarkMode) {
      final systemTheme = SchedulerBinding.instance.window.platformBrightness;
      if (systemTheme == Brightness.dark) {
        return MPaxTheme.dark;
      }
      return MPaxTheme.light;
    }
    // TODO: If not set to follow system theme, get theme in configure.
    if (useDarkTheme.value) {
      return MPaxTheme.dark;
    } else {
      return MPaxTheme.light;
    }
  }

  void saveThemeConfig() {}

  Future<ThemeService> init() async {
    // Load from config.
    followSystemDarkMode =
        _configService.getBool('FollowSystemDarkMode') ?? true;
    useDarkTheme.value = _configService.getBool('UseDarkMode') ?? false;
    return this;
  }
}
