import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';

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
  }) = _Settings;
}

const settingsCurrentMediaPath = 'currentMediaPath';
const settingsCurrentPlaylistId = 'currentPlaylistId';
const settingsPlayMode = 'playMode';
const settingsUseDarkTheme = 'useDarkTheme';
const settingsFollowSystemTheme = 'followSystemTheme';
const settingsVolume = 'volume';

/// All settings and value types.
const Map<String, Type> settingsMap = <String, Type>{
  settingsCurrentMediaPath: String,
  settingsCurrentPlaylistId: int,
  settingsPlayMode: String,
  settingsUseDarkTheme: bool,
  settingsFollowSystemTheme: bool,
  settingsVolume: int,
};
