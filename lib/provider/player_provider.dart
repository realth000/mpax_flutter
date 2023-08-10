import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/playlist_provider.dart';
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

    _player.playbackStateStream.listen((event) async {
      switch (event) {
        case PlaybackState.play:
          ref
              .read(appStateProvider.notifier)
              .setPlayerState(PlayerState.playing);
        case PlaybackState.pause:
          ref.read(appStateProvider.notifier).setPlayerState(PlayerState.pause);
        case PlaybackState.done:
          await playNextFromMode();
      }
    });
  }

  final SimpleAudio _player = SimpleAudio();
  final Ref ref;

  // Mark if stopped, because extra "open file" action is needed
  // to run "play or pause".
  bool _stopped = true;

  Future<void> playMusic(Music music) async {
    final artist = await ref
        .read(databaseProvider.notifier)
        .findArtistNamesByIdList(music.artistList);
    final album = await ref
        .read(databaseProvider.notifier)
        .findAlbumTitleById(music.album);
    final artworkId = music.firstArtwork();
    final artworkData =
        await ref.read(databaseProvider.notifier).findArtworkById(artworkId);
    late final Uint8List artwork;
    if (artworkData == null) {
      artwork = Uint8List(0);
    } else {
      final file = File(artworkData.filePath);
      artwork = await file.readAsBytes();
    }
    await play(
      music.id,
      music.filePath,
      title: music.title,
      artist: artist,
      album: album,
      artwork: artwork,
      artworkId: artworkId,
    );
  }

  Future<void> play(
    int id,
    String filePath, {
    String? title,
    String? artist,
    String? album,
    Uint8List? artwork,
    int? artworkId,
    int? playlistId,
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
          id,
          filePath,
          title ?? '',
          artist ?? '',
          album ?? '',
          artworkId: artworkId,
          playlistId: playlistId,
        );
    ref.read(appStateProvider.notifier).setCurrentMediaInfo(
          id,
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

  /// Skip to previous media in current [Playlist].
  ///
  /// Do nothing if current media not in current playlist, if error occurred.
  /// Skip to the last media if current one is the first one.
  Future<void> playPrevious() async {
    final id = ref.read(appStateProvider).currentMediaId;
    final music = await ref.read(playlistProvider).findPrevious(id);
    if (music == null) {
      return;
    }
    await playMusic(music);
  }

  /// Skip to next media in current [Playlist].
  ///
  /// Do nothing if current media not in current playlist, if error occurred.
  /// Skip to the first media if current one is the last one.
  Future<void> playNext() async {
    final id = ref.read(appStateProvider).currentMediaId;
    final music = await ref.read(playlistProvider).findNext(id);
    if (music == null) {
      return;
    }
    await playMusic(music);
  }

  /// Skip to next media according current [PlayMode].
  ///
  /// If [PlayMode.repeat], skip to next one in current [Playlist].
  /// If [PlayMode.repeatOne], play from beginning of current media.
  /// If [PlayMode.shuffle], skip to random media in current [Playlist].
  Future<void> playNextFromMode() async {
    final playMode = ref.read(appStateProvider).playMode;
    switch (playMode) {
      case PlayMode.repeat:
        await playNext();
      case PlayMode.repeatOne:
        await _replayCurrent();
      case PlayMode.shuffle:
        final music = await ref.read(playlistProvider).random();
        if (music == null) {
          return;
        }
        await playMusic(music);
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
