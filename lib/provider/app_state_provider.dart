import 'package:freezed_annotation/freezed_annotation.dart';
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
    required String currentMediaArtwork,
    required PlayerState playerState,
    required PlayMode playMode,
  }) = _State;
}

@riverpod
class AppState extends _$AppState {
  @override
  State build() {
    return const State(
      screenIndex: 0,
      horizontalPadding: 15.0,
      currentMediaTitle: 'Text title',
      currentMediaArtist: 'Text artist',
      currentMediaAlbum: '',
      currentMediaArtwork: '',
      playerState: PlayerState.Stop,
      playMode: PlayMode.Repeat,
    );
  }

  void setScreenIndex(int index) {
    state = state.copyWith(screenIndex: index);
  }
}
