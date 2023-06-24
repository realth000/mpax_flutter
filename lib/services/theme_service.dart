import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mpax_flutter/services/settings_service.dart';

/// All theme mode in app.
enum MPaxThemeMode {
  /// Follow system.
  auto,

  /// Use dark theme.
  dark,

  /// Use light theme.
  light,
}

/// String for [MPaxThemeMode.auto].
const autoModeString = 'Follow system';

/// String for [MPaxThemeMode.light].
const lightModeString = 'Light mode';

/// String for [MPaxThemeMode.dark].
const darkModeString = 'Dark mode';

/// Controlling theme, globally.
class ThemeService extends GetxService {
  final _configService = Get.find<SettingsService>();

  /// If use dark theme.
  bool useDarkTheme = Get.isDarkMode;

  /// If follow system theme.
  bool followSystemDarkMode = true;

  /// Theme mode string to show on UI.
  final themeModeString = autoModeString.obs;

  /// Change to given [MPaxThemeMode].
  Future<void> changeThemeMode(MPaxThemeMode mode) async {
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
    await saveThemeConfig();
  }

  /// Save theme config to disk.
  Future<void> saveThemeConfig() async {
    await _configService.saveBool('FollowSystemDarkMode', followSystemDarkMode);
    await _configService.saveBool('UseDarkMode', useDarkTheme);
  }

  /// Init function, run before app start.
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
