import 'dart:async';
import 'dart:ui';

import 'mixin/default_settings_model.dart';
import 'settings_repository.dart';

/// Implement [SettingsRepository] with the drift database.
final class SettingsRepositoryImpl
    with DefaultSettingsModel
    implements SettingsRepository {
  @override
  FutureOr<void> clearAccentColor() {
    // TODO: implement clearAccentColor
    throw UnimplementedError();
  }

  @override
  int getAccentColorValue() {
    // TODO: implement getAccentColorValue
    throw UnimplementedError();
  }

  @override
  String getLocale() {
    // TODO: implement getLocale
    throw UnimplementedError();
  }

  @override
  int getThemeMode() {
    // TODO: implement getThemeMode
    throw UnimplementedError();
  }

  @override
  FutureOr<void> setAccentColor(Color color) {
    // TODO: implement setAccentColor
    throw UnimplementedError();
  }

  @override
  FutureOr<void> setLocale(String locale) {
    // TODO: implement setLocale
    throw UnimplementedError();
  }

  @override
  FutureOr<void> setThemeMode(int themeMode) {
    // TODO: implement setThemeMode
    throw UnimplementedError();
  }
}
