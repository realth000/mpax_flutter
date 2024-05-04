import 'dart:ui';

import 'package:mpax_flutter/shared/models/models.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';

/// Interface of database.
///
/// All database source should implement this class to ensure providing
/// all required ability.
abstract interface class StorageProvider {
  StorageProvider._();

  /// Dispose the provider instance.
  ///
  /// Must call this to ensure all resources released.
  Future<void> dispose() async {}

  /// Add a [MusicModel] from [metadataModel] to storage.
  ///
  /// Use [MetadataModel] as parameter because when we call this function,
  /// we are not inside the database, all "material" should be raw data that
  /// not related to database. For example there is no music id nor album id.
  ///
  /// Return added [MusicModel].
  Future<MusicModel> addMusic(MetadataModel metadataModel);

  /// Load all music in [dirPath].
  Future<List<MusicModel>> loadMusicFromStorage(String dirPath);

  /// Load all music in storage, all path version of [loadMusicFromStorage].
  Future<List<MusicModel>> loadAllMusicFromStorage();

  /// Find cached info about file at [filePath].
  ///
  /// Return `null` if not found.
  Future<MusicModel?> findMusicByPath(String filePath);

  /// Delete music model [musicModel] from storage..
  Future<void> deleteMusic(MusicModel musicModel);

  /// Get current holding settings.
  Future<List<SettingsEntity>> getAllSettings();

  /// Set all settings to [settingsModel].
  Future<void> setSettings(SettingsModel settingsModel);

  /// Get current using theme mode index.
  Future<int?> getThemeMode();

  /// Set current using theme mode.
  ///
  /// Save index to storage.
  Future<void> setThemeMode(int themeMode);

  /// Get name of current using locale.
  Future<String?> getLocale();

  /// Save locale name in storage to [locale].
  Future<void> setLocale(String locale);

  /// Get current specified accent color used in theme.
  Future<int?> getAccentColor();

  /// Set current app wide theme color.
  Future<void> setAccentColor(Color color);

  /// Clear app wide specification .
  Future<void> clearAccentColor();

  /// Method get current using log level;
  Future<int?> getLoglevel();

  /// Save loglevel into setLoglevel.
  Future<void> setLoglevel(int loglevel);
}
