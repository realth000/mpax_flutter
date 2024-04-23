import 'dart:ui';

import '../../models/models.dart';

/// Interface of database.
///
/// All database source should implement this class to ensure providing
/// all required ability.
abstract interface class StorageProvider {
  Future<void> addMusic(MusicModel musicModel);

  Future<MusicModel?> findMusicByPath(String filePath);

  Future<void> deleteMusic(MusicModel musicModel);

  Future<int?> getThemeMode();

  Future<void> setThemeMode(int themeMode);

  Future<String?> getLocale();

  Future<void> setLocale(String locale);

  Future<int?> setAccentColor(Color color);

  Future<void> clearAccentColor();

  void dispose() {}
}
