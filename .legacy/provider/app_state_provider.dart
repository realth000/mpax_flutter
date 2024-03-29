import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mpax_flutter/models/settings_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/player_provider.dart';
import 'package:mpax_flutter/provider/playlist_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/provider/app_state_provider.freezed.dart';
part '../generated/provider/app_state_provider.g.dart';

@freezed
class State with _$State {
  const factory State({
    required int screenIndex,
    required double horizontalPadding,
    required int currentMediaId,
    required String currentMediaTitle,
    required String currentMediaArtist,
    required String currentMediaAlbum,
    required Uint8List? currentMediaArtwork,
    required int currentPlaylistId,
    required PlayerPlayState playerState,
    required double playerVolume,
    required double playerLastNotMuteVolume,
    required PlayMode playMode,
    required bool isScanning,
    required String appTheme,
  }) = _State;
}

@Riverpod(keepAlive: true)
class AppState extends _$AppState {
  @override
  State build() {
    final settingsProvider = ref.read(appSettingsProvider);
    final PlayMode playMode;
    switch (settingsProvider.playMode) {
      case 'PlayMode.repeat':
        playMode = PlayMode.repeat;
      case 'PlayMode.repeatOne':
        playMode = PlayMode.repeatOne;
      case 'PlayMode.shuffle':
        playMode = PlayMode.shuffle;
      default:
        playMode = PlayMode.repeat;
    }

    // TODO: Fetch metadata from file.
    // Here is a thumb from database.
    final artwork = ref
        .read(databaseProvider)
        .findArtworkByIdSync(settingsProvider.lastPlayedArtworkId);
    Uint8List? artworkData;
    if (artwork != null) {
      final file = File(artwork.filePath);
      artworkData = file.readAsBytesSync();
    }

    ref.read(playlistProvider).setPlaylistById(settingsProvider.lastPlaylistId);

    return State(
      screenIndex: 0,
      horizontalPadding: 15.0,
      currentMediaId: settingsProvider.lastPlayedId,
      currentMediaTitle: settingsProvider.lastPlayedTitle,
      currentMediaArtist: settingsProvider.lastPlayedArtist,
      currentMediaAlbum: settingsProvider.lastPlayedAlbum,
      currentMediaArtwork: artworkData,
      currentPlaylistId: settingsProvider.lastPlaylistId,
      playerState: PlayerPlayState.stop,
      playerVolume: settingsProvider.playerVolume,
      playerLastNotMuteVolume: settingsProvider.playerLastNotMuteVolume,
      playMode: playMode,
      isScanning: false,
      appTheme: settingsProvider.appTheme,
    );
  }

  void setScreenIndex(int index) {
    state = state.copyWith(screenIndex: index);
  }

  void setPlayerState(PlayerPlayState playerState) {
    state = state.copyWith(playerState: playerState);
  }

  Future<void> setCurrentPlaylistInfo(int id) async {
    state = state.copyWith(currentPlaylistId: id);
    await ref.read(appSettingsProvider.notifier).setLastPlaylist(id);
  }

  Future<void> setCurrentMediaInfo(int id, String filePath, String title,
      String artist, String album, int? artworkId, int? playlistId,
      {Uint8List? artwork}) async {
    state = state.copyWith(
      currentMediaId: id,
      currentMediaTitle: title,
      currentMediaArtist: artist,
      currentMediaAlbum: album,
      currentMediaArtwork: artwork,
    );

    await ref.read(appSettingsProvider.notifier).setLastPlayed(
          id,
          filePath,
          title,
          artist,
          album,
          artworkId: artworkId,
          playlistId: playlistId,
        );
  }

  Future<void> setPlayMode(PlayMode playMode) async {
    state = state.copyWith(playMode: playMode);
    await ref
        .read(appSettingsProvider.notifier)
        .setPlayMode(PlayMode.repeatOne.toString());
  }

  void setScanning(bool scanning) {
    state = state.copyWith(isScanning: scanning);
  }

  Future<void> setAppTheme(String theme) async {
    switch (theme) {
      case appThemeLight || appThemeSystem || appThemeDark:
        state = state.copyWith(appTheme: theme);
        await ref.read(appSettingsProvider.notifier).setAppTheme(theme);
      default:
    }
  }

  Future<void> setPlayerVolume(double volume) async {
    final double v = min(volume, 1);
    if (v != 0) {
      state = state.copyWith(playerVolume: v, playerLastNotMuteVolume: v);
    } else {
      state = state.copyWith(playerVolume: v);
    }

    await ref.read(appSettingsProvider.notifier).setPlayerVolume(v);
  }
}
