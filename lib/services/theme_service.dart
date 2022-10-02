import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';

enum MPaxThemeMode {
  auto,
  dark,
  light,
}

const autoModeString = 'Follow system';
const lightModeString = 'Light mode';
const darkModeString = 'Dark mode';

class ThemeService extends GetxService {
  final _configService = Get.find<ConfigService>();

  // Theme settings.
  bool useDarkTheme = Get.isDarkMode;
  bool followSystemDarkMode = true;
  final themeModeString = autoModeString.obs;

  void changeThemeMode(MPaxThemeMode mode) {
    if (mode == MPaxThemeMode.auto) {
      followSystemDarkMode = true;
      themeModeString.value = autoModeString;
      Get.changeThemeMode(ThemeMode.system);
    } else if (mode == MPaxThemeMode.dark) {
      followSystemDarkMode = false;
      useDarkTheme = true;
      themeModeString.value = darkModeString;
      Get.changeThemeMode(ThemeMode.dark);
    } else if (mode == MPaxThemeMode.light) {
      followSystemDarkMode = false;
      useDarkTheme = false;
      themeModeString.value = lightModeString;
      Get.changeThemeMode(ThemeMode.light);
    }
    saveThemeConfig();
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
    if (followSystemDarkMode) {
      themeModeString.value = autoModeString;
      Get.changeThemeMode(ThemeMode.system);
    } else if (useDarkTheme) {
      themeModeString.value = darkModeString;
      Get.changeThemeMode(ThemeMode.dark);
    } else {
      themeModeString.value = lightModeString;
      Get.changeThemeMode(ThemeMode.light);
    }
    return this;
  }
}
