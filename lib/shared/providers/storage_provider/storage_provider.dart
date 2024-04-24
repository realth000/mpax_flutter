import 'dart:ui';

import '../../models/models.dart';
import 'database/database.dart';

/// Interface of database.
///
/// All database source should implement this class to ensure providing
/// all required ability.
abstract interface class StorageProvider {
  StorageProvider._();

  Future<void> dispose() async {}

  Future<void> addMusic(MusicModel musicModel);

  Future<MusicModel?> findMusicByPath(String filePath);

  Future<void> deleteMusic(MusicModel musicModel);

  Future<List<SettingsEntity>> getAllSettings();

  Future<void> setSettings(SettingsModel settingsModel);

  Future<int?> getThemeMode();

  Future<void> setThemeMode(int themeMode);

  Future<String?> getLocale();

  Future<void> setLocale(String locale);

  Future<int?> getAccentColor();

  Future<void> setAccentColor(Color color);

  Future<void> clearAccentColor();
}
