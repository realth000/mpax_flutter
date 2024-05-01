import 'package:flutter/material.dart';
import 'package:mpax_flutter/features/logging/enums/loglevel.dart';
import 'package:mpax_flutter/shared/models/models.dart';

/// Default values of app settings.
///
/// All settings provider implementation MUST mix with this mixin.
mixin DefaultSettingsModel {
  /// Get default settings.
  SettingsModel get allDefault => SettingsModel(
        themeMode: defaultThemeMode,
        locale: defaultLocale,
        accentColor: defaultAccentColor,
        loglevel: defaultLoglevel,
      );

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

  /// Loglevel.
  ///
  /// Only show errors.
  Loglevel get defaultLoglevel => Loglevel.error;
}
