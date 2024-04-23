import 'package:flutter/material.dart';

/// Default values of app settings.
///
/// All settings provider implementation MUST mix with this mixin.
mixin DefaultSettingsModel {
  /// Theme mode index.
  ///
  /// 0: [ThemeMode.system].
  /// 1: [ThemeMode.light].
  /// 2: [ThemeMode.dark].
  int get defaultThemeMode => ThemeMode.system.index;

  /// Locale name.
  ///
  /// Empty locale name means using system locale.
  String get defaultLocale => '';

  /// Accent color value.
  ///
  /// A less than zero values means using default accent color.
  int get defaultAccentColor => -1;
}
