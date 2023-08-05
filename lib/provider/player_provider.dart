import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/widgets/play_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_audio/simple_audio.dart';

part 'player_provider.g.dart';

class Player {
  Player(this.ref) {
    _player.progressStateStream.listen((event) {
      ref.read(appStateProvider.notifier).setPlayerPositionAndDuration(
          event.position.toDouble(), event.duration.toDouble());
    });

    _player.playbackStateStream.listen((event) {
      switch (event) {
        case PlaybackState.play:
          ref
              .read(appStateProvider.notifier)
              .setPlayerState(PlayerState.playing);
        case PlaybackState.pause:
          ref.read(appStateProvider.notifier).setPlayerState(PlayerState.pause);
        case PlaybackState.done:
          final playMode = ref.read(appStateProvider).playMode;
          switch (playMode) {
            case PlayMode.repeat:
              // TODO: Playlist next item.
              ref
                  .read(appStateProvider.notifier)
                  .setPlayerState(PlayerState.stop);
            case PlayMode.repeatOne:
              _replayCurrent();
            case PlayMode.shuffle:
              // TODO: Playlist shuffle item.
              ref
                  .read(appStateProvider.notifier)
                  .setPlayerState(PlayerState.stop);
          }
      }
    });
  }

  final SimpleAudio _player = SimpleAudio();
  final Ref ref;

  // Mark if stopped, because extra "open file" action is needed
  // to run "play or pause".
  bool _stopped = true;

  Future<void> play(
    String filePath, {
    String? title,
    String? artist,
    String? album,
    Uint8List? artwork,
    int? artworkId,
  }) async {
    await _player.stop();
    await _player.setMetadata(Metadata(
      title: title,
      artist: artist,
      album: album,
      artBytes: artwork,
    ));
    await _player.open(filePath);
    await ref.read(appSettingsProvider.notifier).setLastPlayed(
          filePath,
          title ?? '',
          artist ?? '',
          album ?? '',
          artworkId: artworkId,
        );
    ref.read(appStateProvider.notifier).setCurrentMediaInfo(
          title ?? '',
          artist ?? '',
          album ?? '',
          artwork: artwork,
        );
    await _player.play();
    _stopped = false;
  }

  Future<void> playOrPause() async {
    if (await _player.isPlaying) {
      await _player.pause();
    } else {
      // If stopped, load the file first.
      if (_stopped) {
        final filePath = ref.read(appSettingsProvider).lastPlayedFilePath;
        if (filePath.isNotEmpty) {
          await _player.open(filePath);
        } else {
          // If stopped and no file loaded before, do nothing.
          return;
        }
      }
      await _player.play();
      _stopped = false;
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _stopped = true;
  }

  Future<void> switchPlayMode() async {
    final currentPlayMode = ref.read(appStateProvider).playMode;
    switch (currentPlayMode) {
      case PlayMode.repeat:
        await ref
            .read(appSettingsProvider.notifier)
            .setPlayMode(PlayMode.repeatOne.toString());
        ref.read(appStateProvider.notifier).setPlayMode(PlayMode.repeatOne);
      case PlayMode.repeatOne:
        await ref
            .read(appSettingsProvider.notifier)
            .setPlayMode(PlayMode.shuffle.toString());
        ref.read(appStateProvider.notifier).setPlayMode(PlayMode.shuffle);
      case PlayMode.shuffle:
        await ref
            .read(appSettingsProvider.notifier)
            .setPlayMode(PlayMode.repeat.toString());
        ref.read(appStateProvider.notifier).setPlayMode(PlayMode.repeat);
    }
  }

  Future<bool> _replayCurrent() async {
    final filePath = ref.read(appSettingsProvider).lastPlayedFilePath;
    if (filePath.isEmpty) {
      return false;
    }
    await _player.open(filePath);
    await _player.play();
    return true;
  }

  Future<void> seekToPosition(double position) async {
    await _player.seek(position.toInt());
  }
}

@Riverpod(keepAlive: true)
Player player(PlayerRef ref) => Player(ref);
