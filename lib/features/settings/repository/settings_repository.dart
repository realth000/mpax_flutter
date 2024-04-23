import 'dart:async';
import 'dart:ui';

/// Basic functionality required to settings repository.
abstract interface class SettingsRepository {
  /// Get current theme mode index;
  int getThemeMode();

  /// Set theme mode index.
  FutureOr<void> setThemeMode(int themeMode);

  /// Get locale name string.
  String getLocale();

  /// Set locale name.
  FutureOr<void> setLocale(String locale);

  /// Get the value of app accent color.
  int getAccentColorValue();

  /// Set accent color.
  FutureOr<void> setAccentColor(Color color);

  /// Clear the accent color settings.
  FutureOr<void> clearAccentColor();
}
