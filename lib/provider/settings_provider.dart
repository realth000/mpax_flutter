import 'package:mpax_flutter/models/settings_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

late final _SettingsService _settings;
bool _initialized = false;

Future<void> initSettings() async {
  if (_initialized) {
    return;
  }
  _settings = await _SettingsService().init();
  _initialized = true;
}

class _SettingsService {
  late final SharedPreferences _sp;

  Future<_SettingsService> init() async {
    _sp = await SharedPreferences.getInstance();
    return this;
  }

  dynamic get(String key) => _sp.get(key);

  /// Get int type value of specified key.
  int? getInt(String key) => _sp.getInt(key);

  /// Sae int type value of specified key.
  Future<bool> saveInt(String key, int value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setInt(key, value);
    return true;
  }

  /// Get bool type value of specified key.
  bool? getBool(String key) => _sp.getBool(key);

  /// Save bool type value of specified value.
  Future<bool> saveBool(String key, bool value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setBool(key, value);
    return true;
  }

  /// Get double type value of specified key.
  double? getDouble(String key) => _sp.getDouble(key);

  /// Save double type value of specified key.
  Future<bool> saveDouble(String key, double value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setDouble(key, value);
    return true;
  }

  /// Get string type value of specified key.
  String? getString(String key) => _sp.getString(key);

  /// Save string type value of specified key.
  Future<bool> saveString(String key, String value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setString(key, value);
    return true;
  }

  /// Get string list type value of specified key.
  List<String>? getStringList(String key) => _sp.getStringList(key);

  /// Save string list type value of specified key.
  Future<bool> saveStringList(String key, List<String> value) async {
    if (!settingsMap.containsKey(key)) {
      return false;
    }
    await _sp.setStringList(key, value);
    return true;
  }
}

@riverpod
class AppSettings extends _$AppSettings {
  @override
  Settings build() {
    initSettings();

    return Settings(
      currentMediaPath: _settings.getString(settingsCurrentMediaPath) ??
          _defaultCurrentMediaPath,
      currentPlaylistId: _settings.getInt(settingsCurrentPlaylistId) ??
          _defaultCurrentPlaylistId,
      playMode: _settings.getString(settingsPlayMode) ?? _defaultPlayMode,
      useDarkTheme:
          _settings.getBool(settingsUseDarkTheme) ?? _defaultUseDarkMode,
      followSystemTheme: _settings.getBool(settingsFollowSystemTheme) ??
          _defaultFollowSystemTheme,
      volume: _settings.getInt(settingsVolume) ?? _defaultVolume,
      scanDirectoryList: _settings.getStringList(settingsScanDirectoryList) ??
          _defaultScanDirectoryList,
      lastPlayedId:
          _settings.getInt(settingsLastPlayedId) ?? _defaultLastPlayedId,
      lastPlayedFilePath: _settings.getString(settingsLastPlayedFilePath) ??
          _defaultLastPlayedFilePath,
      lastPlayedTitle: _settings.getString(settingsLastPlayedTitle) ??
          _defaultLastPlayedTitle,
      lastPlayedArtist: _settings.getString(settingsLastPlayedArtist) ??
          _defaultLastPlayedArtist,
      lastPlayedAlbum: _settings.getString(settingsLastPlayedAlbum) ??
          _defaultLastPlayedAlbum,
      lastPlayedArtworkId: _settings.getInt(settingsLastPlayedArtworkId) ??
          _defaultLastPlayedArtworkId,
      lastPlaylistId:
          _settings.getInt(settingsLastPlaylistId) ?? _defaultLastPlaylistId,
    );
  }

  static const _defaultCurrentMediaPath = '';
  static const _defaultCurrentPlaylistId = 0;
  static const _defaultPlayMode = '';
  static const _defaultUseDarkMode = false;
  static const _defaultFollowSystemTheme = true;
  static const _defaultVolume = 30;
  static const _defaultScanDirectoryList = <String>[];
  static const _defaultLastPlayedFilePath = '';
  static const _defaultLastPlayedId = -1;
  static const _defaultLastPlayedTitle = '';
  static const _defaultLastPlayedArtist = '';
  static const _defaultLastPlayedAlbum = '';
  static const _defaultLastPlayedArtworkId = -1;
  static const _defaultLastPlaylistId = -1;

  Future<void> setCurrentMediaPath(String currentMediaPath) async {
    state = state.copyWith(currentMediaPath: currentMediaPath);
    await _settings.saveString(settingsCurrentMediaPath, currentMediaPath);
  }

  Future<void> setCurrentPlaylistId(int currentPlaylistId) async {
    state = state.copyWith(currentPlaylistId: currentPlaylistId);
    await _settings.saveInt(settingsCurrentPlaylistId, currentPlaylistId);
  }

  Future<void> setPlayMode(String playMode) async {
    state = state.copyWith(playMode: playMode);
    await _settings.saveString(settingsPlayMode, playMode);
  }

  Future<void> setUseDarkTheme(bool useDarkTheme) async {
    state = state.copyWith(useDarkTheme: useDarkTheme);
    await _settings.saveBool(settingsUseDarkTheme, useDarkTheme);
  }

  Future<void> setFollowSystemTheme(bool followSystemTheme) async {
    state = state.copyWith(followSystemTheme: followSystemTheme);
    await _settings.saveBool(settingsFollowSystemTheme, followSystemTheme);
  }

  Future<void> setVolume(int volume) async {
    state = state.copyWith(volume: volume);
    await _settings.saveInt(settingsVolume, volume);
  }

  Future<void> addScanDirectory(String directory) async {
    // Use toSet() to remove duplicate directories.
    final list = state.scanDirectoryList.toList()
      ..add(directory)
      ..toSet()
      ..toList();
    state = state.copyWith(scanDirectoryList: list);
    await _settings.saveStringList(settingsScanDirectoryList, list);
  }

  Future<void> addScanDirectories(List<String> directories) async {
    // Use toSet() to remove duplicate directories.
    final list = state.scanDirectoryList.toList()
      ..addAll(directories)
      ..toSet()
      ..toList();
    state = state.copyWith(scanDirectoryList: list);
    await _settings.saveStringList(settingsScanDirectoryList, list);
  }

  Future<void> removeScanDirectory(String directory) async {
    final list = state.scanDirectoryList.toList()..remove(directory);
    state = state.copyWith(scanDirectoryList: list);
    await _settings.saveStringList(settingsScanDirectoryList, list);
  }

  Future<void> setLastPlayed(
      int id, String filePath, String title, String artist, String album,
      {int? artworkId, int? playlistId}) async {
    final oldPlaylistId = state.lastPlaylistId;
    state = state.copyWith(
      lastPlayedId: id,
      lastPlayedFilePath: filePath,
      lastPlayedTitle: title,
      lastPlayedArtist: artist,
      lastPlayedAlbum: album,
      lastPlayedArtworkId: artworkId ?? -1,
      lastPlaylistId: playlistId ?? oldPlaylistId,
    );
    await _settings.saveInt(settingsLastPlayedId, id);
    await _settings.saveString(settingsLastPlayedFilePath, filePath);
    await _settings.saveString(settingsLastPlayedTitle, title);
    await _settings.saveString(settingsLastPlayedArtist, artist);
    await _settings.saveString(settingsLastPlayedAlbum, album);
    await _settings.saveInt(settingsLastPlayedArtworkId, artworkId ?? -1);
    await _settings.saveInt(
        settingsLastPlaylistId, playlistId ?? oldPlaylistId);
  }

  Future<void> setLastPlaylist(int id) async {
    state = state.copyWith(lastPlaylistId: id);
    await _settings.saveInt(settingsLastPlaylistId, id);
  }
}
