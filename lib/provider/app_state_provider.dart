import 'dart:convert';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/widgets/play_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_state_provider.freezed.dart';
part 'app_state_provider.g.dart';

@freezed
class State with _$State {
  const factory State({
    required int screenIndex,
    required double horizontalPadding,
    required String currentMediaTitle,
    required String currentMediaArtist,
    required String currentMediaAlbum,
    required Uint8List? currentMediaArtwork,
    required PlayerState playerState,
    required double playerPosition,
    required double playerDuration,
    required double playerVolume,
    required PlayMode playMode,
    required bool isScanning,
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
        .read(databaseProvider.notifier)
        .findArtworkByIdSync(settingsProvider.lastPlayedArtworkId);
    Uint8List? artworkData;
    if (artwork != null) {
      artworkData = base64Decode(artwork.data);
    }

    return State(
      screenIndex: 0,
      horizontalPadding: 15.0,
      currentMediaTitle: settingsProvider.lastPlayedTitle,
      currentMediaArtist: settingsProvider.lastPlayedArtist,
      currentMediaAlbum: settingsProvider.lastPlayedAlbum,
      currentMediaArtwork: artworkData,
      playerState: PlayerState.stop,
      playerPosition: 0,
      playerDuration: 0,
      playerVolume: 30,
      playMode: playMode,
      isScanning: false,
    );
  }

  void setScreenIndex(int index) {
    state = state.copyWith(screenIndex: index);
  }

  void setPlayerState(PlayerState playerState) {
    state = state.copyWith(playerState: playerState);
  }

  void setCurrentMediaInfo(String title, String artist, String album,
      {Uint8List? artwork}) {
    state = state.copyWith(
      currentMediaTitle: title,
      currentMediaArtist: artist,
      currentMediaAlbum: album,
      currentMediaArtwork: artwork,
    );
  }

  void setPlayerPositionAndDuration(double position, double duration) {
    state = state.copyWith(
      playerPosition: position,
      playerDuration: duration,
    );
  }

  void setPlayMode(PlayMode playMode) {
    state = state.copyWith(playMode: playMode);
  }

  void setScanning(bool scanning) {
    state = state.copyWith(isScanning: scanning);
  }
}
