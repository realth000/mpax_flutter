import 'dart:ui';

import '../../models/models.dart';
import 'database/database.dart';
import 'storage_provider.dart';

/// Implementation of [StorageProvider].
final class StorageProviderImpl implements StorageProvider {
  /// Constructor.
  StorageProviderImpl(this._appDatabase);

  final AppDatabase _appDatabase;

  @override
  Future<void> addMusic(MusicModel musicModel) {
    // TODO: implement addMusic
    throw UnimplementedError();
  }

  @override
  Future<void> clearAccentColor() {
    // TODO: implement clearAccentColor
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMusic(MusicModel musicModel) {
    // TODO: implement deleteMusic
    throw UnimplementedError();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future<MusicModel?> findMusicByPath(String filePath) {
    // TODO: implement findMusicByPath
    throw UnimplementedError();
  }

  @override
  Future<String?> getLocale() {
    // TODO: implement getLocale
    throw UnimplementedError();
  }

  @override
  Future<int?> getThemeMode() {
    // TODO: implement getThemeMode
    throw UnimplementedError();
  }

  @override
  Future<int?> setAccentColor(Color color) {
    // TODO: implement setAccentColor
    throw UnimplementedError();
  }

  @override
  Future<void> setLocale(String locale) {
    // TODO: implement setLocale
    throw UnimplementedError();
  }

  @override
  Future<void> setThemeMode(int themeMode) {
    // TODO: implement setThemeMode
    throw UnimplementedError();
  }
}
