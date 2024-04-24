import 'dart:async';
import 'dart:ui';

import '../../../shared/models/models.dart';

/// Basic functionality required to settings repository.
abstract interface class SettingsRepository {
  /// Dispose resources.
  FutureOr<void> dispose();

  FutureOr<SettingsModel> getCurrentSettings();

  FutureOr<void> setSettings(SettingsModel settingsModel);

  SettingsModel getDefaultSettings();

  /// Get current theme mode index;
  FutureOr<int> getThemeMode();

  /// Set theme mode index.
  FutureOr<void> setThemeMode(int themeMode);

  /// Get locale name string.
  FutureOr<String> getLocale();

  /// Set locale name.
  FutureOr<void> setLocale(String locale);

  /// Get the value of app accent color.
  FutureOr<int> getAccentColorValue();

  /// Set accent color.
  FutureOr<void> setAccentColor(Color color);

  /// Clear the accent color settings.
  FutureOr<void> clearAccentColor();
}
