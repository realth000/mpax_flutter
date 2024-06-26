import 'dart:async';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mpax_flutter/features/logging/enums/loglevel.dart';
import 'package:mpax_flutter/features/settings/repository/mixin/default_settings_model.dart';
import 'package:mpax_flutter/features/settings/repository/settings_repository.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';

/// Implement [SettingsRepository] with the drift database.
final class SettingsRepositoryImpl
    with DefaultSettingsModel
    implements SettingsRepository {
  /// Constructor.
  SettingsRepositoryImpl(this._storageProvider);

  final StorageProvider _storageProvider;

  @override
  FutureOr<void> dispose() async {
    logger.i('dispose SettingsRepositoryImpl');
    await _storageProvider.dispose();
  }

  @override
  FutureOr<SettingsModel> getCurrentSettings() async {
    final allSettings = await _storageProvider.getAllSettings();
    var d = allDefault;
    for (final s in allSettings) {
      d = switch (s.name) {
        SettingsKeys.themeMode => d.copyWith(themeMode: s.intValue),
        SettingsKeys.locale => d.copyWith(locale: s.stringValue),
        SettingsKeys.accentColor => d.copyWith(accentColor: s.intValue),
        SettingsKeys.loglevel => d.copyWith(
            loglevel: Loglevel.values
                    .firstWhereOrNull((e) => e.index == s.intValue) ??
                Loglevel.error,
          ),
        _ => d,
      };
    }
    return d;
  }

  @override
  FutureOr<void> setSettings(SettingsModel settingsModel) async {
    await _storageProvider.setSettings(settingsModel);
  }

  @override
  SettingsModel getDefaultSettings() => allDefault;

  @override
  FutureOr<int> getThemeMode() async {
    return await _storageProvider.getThemeMode() ?? defaultThemeMode;
  }

  @override
  FutureOr<void> setThemeMode(int themeMode) async {
    await _storageProvider.setThemeMode(themeMode);
  }

  @override
  FutureOr<int> getAccentColorValue() async {
    return await _storageProvider.getAccentColor() ?? defaultAccentColor;
  }

  @override
  FutureOr<void> setAccentColor(Color color) async {
    await _storageProvider.setAccentColor(color);
  }

  @override
  FutureOr<void> clearAccentColor() async {
    await _storageProvider.clearAccentColor();
  }

  @override
  FutureOr<String> getLocale() async {
    return await _storageProvider.getLocale() ?? defaultLocale;
  }

  @override
  FutureOr<void> setLocale(String locale) async {
    await _storageProvider.setLocale(locale);
  }

  @override
  FutureOr<Loglevel> getLoglevel() async {
    final levelValue = await _storageProvider.getLoglevel();
    if (levelValue == null ||
        Loglevel.values.none((e) => e.index == levelValue)) {
      return defaultLoglevel;
    }
    return Loglevel.values[levelValue];
  }

  @override
  FutureOr<void> setLoglevel(Loglevel loglevel) async {
    await _storageProvider.setLoglevel(loglevel.index);
  }
}
