import 'dart:ui';

import 'package:drift/drift.dart';

import '../../../instance.dart';
import '../../models/models.dart';
import 'database/dao/settings.dart';
import 'database/database.dart';
import 'storage_provider.dart';

/// Implementation of [StorageProvider].
final class StorageProviderImpl implements StorageProvider {
  /// Constructor.
  StorageProviderImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> dispose() async {
    logger.i('dispose SettingsProviderImpl');
    await _db.close();
  }

  @override
  Future<void> addMusic(MusicModel musicModel) {
    // TODO: implement addMusic
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMusic(MusicModel musicModel) {
    // TODO: implement deleteMusic
    throw UnimplementedError();
  }

  @override
  Future<MusicModel?> findMusicByPath(String filePath) {
    // TODO: implement findMusicByPath
    throw UnimplementedError();
  }

  @override
  Future<List<SettingsEntity>> getAllSettings() async {
    return SettingsDao(_db).selectAll();
  }

  @override
  Future<void> setSettings(SettingsModel settingsModel) async {
    final list = [
      SettingsCompanion.insert(
        name: SettingsKeys.themeMode,
        intValue: Value(settingsModel.themeMode),
      ),
      SettingsCompanion.insert(
        name: SettingsKeys.accentColor,
        intValue: Value(settingsModel.accentColor),
      ),
      SettingsCompanion.insert(
        name: SettingsKeys.locale,
        stringValue: Value(settingsModel.locale),
      ),
    ];
    await SettingsDao(_db).upsertManySettings(list);
  }

  @override
  Future<int?> getThemeMode() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.themeMode,
    );
    return entity?.intValue;
  }

  @override
  Future<void> setThemeMode(int themeMode) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.themeMode),
        intValue: Value(themeMode),
      ),
    );
  }

  @override
  Future<int?> getAccentColor() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.accentColor,
    );
    return entity?.intValue;
  }

  @override
  Future<void> setAccentColor(Color color) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
          name: const Value(SettingsKeys.accentColor),
          intValue: Value(color.value)),
    );
  }

  @override
  Future<void> clearAccentColor() async {
    await SettingsDao(_db).upsertSettings(
      const SettingsCompanion(
        name: Value(SettingsKeys.accentColor),
        intValue: Value(null),
      ),
    );
  }

  @override
  Future<String?> getLocale() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.locale,
    );
    return entity?.stringValue;
  }

  @override
  Future<void> setLocale(String locale) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.locale),
        stringValue: Value(locale),
      ),
    );
  }

  @override
  Future<int?> getLoglevel() async {
    final entity = await SettingsDao(_db).selectSettingsByName(
      SettingsKeys.loglevel,
    );
    return entity?.intValue;
  }

  @override
  Future<void> setLoglevel(int loglevel) async {
    await SettingsDao(_db).upsertSettings(
      SettingsCompanion(
        name: const Value(SettingsKeys.loglevel),
        intValue: Value(loglevel),
      ),
    );
  }
}
