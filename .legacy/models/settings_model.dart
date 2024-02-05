import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/settings_model.freezed.dart';

/// Settings model for app and used in storage.
@freezed
class Settings with _$Settings {
  /// Constructor.
  const factory Settings({
    required String currentMediaPath,
    required int currentPlaylistId,
    required String playMode,
    required bool useDarkTheme,
    required bool followSystemTheme,
    required int volume,
    required List<String> scanDirectoryList,
    required int lastPlayedId,
    required String lastPlayedFilePath,
    required String lastPlayedTitle,
    required String lastPlayedArtist,
    required String lastPlayedAlbum,
    required int lastPlayedArtworkId,
    required int lastPlaylistId,
    required String appTheme,
    required double playerVolume,
    required double playerLastNotMuteVolume,
  }) = _Settings;
}

const settingsCurrentMediaPath = 'currentMediaPath';
const settingsCurrentPlaylistId = 'currentPlaylistId';
const settingsPlayMode = 'playMode';
const settingsUseDarkTheme = 'useDarkTheme';
const settingsFollowSystemTheme = 'followSystemTheme';
const settingsVolume = 'volume';
const settingsScanDirectoryList = 'scanDirectoryList';
const settingsLastPlayedId = 'lastPlayedId';
const settingsLastPlayedFilePath = 'lastPlayedFilePath';
const settingsLastPlayedTitle = 'lastPlayedTitle';
const settingsLastPlayedArtist = 'lastPlayedArtist';
const settingsLastPlayedAlbum = 'lastPlayedAlbum';
const settingsLastPlayedArtworkId = 'lastPlayedArtworkId';
const settingsLastPlaylistId = 'lastPlaylistId';
const settingsAppTheme = 'appTheme';
const settingsPlayerVolume = 'playerVolume';
const settingsPlayerLastNotMuteVolume = 'playerLastNotMuteVolume';

/// All settings and value types.
const Map<String, Type> settingsMap = <String, Type>{
  settingsCurrentMediaPath: String,
  settingsCurrentPlaylistId: int,
  settingsPlayMode: String,
  settingsUseDarkTheme: bool,
  settingsFollowSystemTheme: bool,
  settingsVolume: int,
  settingsScanDirectoryList: List<String>,
  settingsLastPlayedId: int,
  settingsLastPlayedFilePath: String,
  settingsLastPlayedTitle: String,
  settingsLastPlayedArtist: String,
  settingsLastPlayedAlbum: String,
  settingsLastPlayedArtworkId: int,
  settingsLastPlaylistId: int,
  settingsAppTheme: String,
  settingsPlayerVolume: double,
  settingsPlayerLastNotMuteVolume: double,
};

const appThemeLight = 'light';
const appThemeSystem = 'system';
const appThemeDark = 'dark';
