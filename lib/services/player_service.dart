import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../models/play_content.model.dart';
import '../models/playlist.model.dart';
import '../services/config_service.dart';
import '../services/media_library_service.dart';
import '../services/metadata_service.dart';

/// Wrapper for mobile
class PlayerWrapper extends BaseAudioHandler with QueueHandler, SeekHandler {
  // The most common callbacks:
  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
    await Get.find<PlayerService>().playOrPause();
  }

  Future<void> pause() async {
    await Get.find<PlayerService>().playOrPause();
  }

  Future<void> stop() async {
    await Get.find<PlayerService>().playOrPause();
  }

  Future<void> seek(Duration position) async {
    await Get.find<PlayerService>().seekToDuration(position);
  }

  Future<void> skipToQueueItem(int i) async {
    if (i > 0) {
      await Get.find<PlayerService>().seekToAnother(true);
    } else {
      await Get.find<PlayerService>().seekToAnother(false);
    }
  }
}

/// In charge of playing audio file, globally.
class PlayerService extends GetxService {
  PlayerService({this.wrapper});

  // State
  static const IconData _playIcon = Icons.play_arrow;
  static const IconData _pauseIcon = Icons.pause;
  static const IconData _repeatIcon = Icons.repeat;
  static const _repeatString = 'Repeat';
  static const _repeatOneString = 'RepeatOne';
  static const _shuffleString = 'Shuffle';
  static const IconData _repeatOneIcon = Icons.repeat_one;
  static const IconData _shuffleIcon = Icons.shuffle;

  final _configService = Get.find<ConfigService>();
  final _libraryService = Get.find<MediaLibraryService>();
  final _player = AudioPlayer();

  /// Only use on mobile platforms.
  final PlayerWrapper? wrapper;

  /// Play history, only uses in shuffle mode([playMode] == [_shuffleString]).
  /// Usage and behavior act like foobar2000's play history.
  ///
  /// In the following situations, this history list will append items:
  /// * In shuffle mode, and caller is a "seek to next" action, not "play xxx"
  /// audio".
  ///
  /// In the following situations, use this history list:
  /// * In shuffle mode, and caller is a "seek to previous" action, not "play
  /// xxx audio" and current playing position is not head or tail of history
  /// list.
  ///
  /// In the following situations, the history will clear all items:
  /// * Caller is "play xxx audio", no matter in shuffle mode or not.
  /// * Switch to another playlist.
  final playHistoryList = <PlayContent>[];

  /// Current playing audio position stream.
  late Stream<Duration> positionStream = _player.onPositionChanged;

  /// Current playing audio duration stream.
  late Stream<Duration?> durationStream = _player.onDurationChanged;

  /// Current playing position.
  final currentPosition = Duration.zero.obs;

  /// Current duration position.
  final currentDuration = const Duration(seconds: 1).obs;
  late final StreamSubscription<Duration> positionSub;
  late final StreamSubscription<Duration?> durationSub;

  /// Player volume
  ///
  /// [0, 1], 0 == mute, 1 == max volume.
  final volume = 0.3.obs;

  /// Current playing playlist.
  PlaylistModel currentPlaylist = PlaylistModel();

  /// Current playing content.
  final currentContent = PlayContent().obs;

  /// Current play mode.
  String playMode = _repeatString;

  /// Show on play or pause.
  Rx<IconData> playButtonIcon = _playIcon.obs;

  /// Show play mode.
  Rx<IconData> playModeIcon = _repeatIcon.obs;

  // late final StreamSubscription<ProcessingState> _playerDurationStream;

  /// Set and save player volume.
  Future<void> saveVolume(double volume) async {
    if (volume > 1) {
      return;
    }
    await _player.setVolume(volume);
    this.volume.value = volume;
    await Get.find<ConfigService>().saveDouble('PlayerVolume', volume);
  }

  Future<PlaybackState> _transformEvent(PlayerState event) async =>
      PlaybackState(
        controls: [
          MediaControl.rewind,
          if (event == PlayerState.playing)
            MediaControl.pause
          else
            MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          PlayerState.stopped: AudioProcessingState.idle,
          PlayerState.playing: AudioProcessingState.ready,
          PlayerState.paused: AudioProcessingState.ready,
          PlayerState.completed: AudioProcessingState.completed,
        }[_player.state]!,
        playing: _player.state == PlayerState.playing,
        updatePosition: await _player.getCurrentPosition() ?? Duration.zero,
        queueIndex: 0,
      );

  /// Init function, run before app start.
  Future<PlayerService> init() async {
    final v = Get.find<ConfigService>().getDouble('PlayerVolume');
    if (v != null) {
      volume.value = v;
      await _player.setVolume(volume.value);
    }
    if (GetPlatform.isMobile) {
      _player.onPlayerStateChanged.listen((state) async {
        wrapper!.playbackState.add(await _transformEvent(state));
      });
    }
    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        playButtonIcon.value = _pauseIcon;
      } else {
        playButtonIcon.value = _playIcon;
      }
    });
    _player.onPlayerComplete.listen((state) async {
      if (playMode == _repeatOneString) {
        await _player.seek(Duration.zero);
        await _player.resume();
      } else {
        await seekToAnother(true);
      }
    });
    positionSub = _player.onPositionChanged.listen((position) {
      if (position < Duration.zero) {
        currentPosition.value = Duration.zero;
      } else {
        currentPosition.value = position;
      }
    });
    durationSub = _player.onDurationChanged.listen((duration) {
      if (duration < Duration.zero) {
        currentDuration.value = const Duration(seconds: 1);
      } else {
        currentDuration.value = duration;
      }
    });
    // Load configs.
    final currentMedia = File(_configService.getString('CurrentMedia') ?? '');
    if (currentMedia.existsSync()) {
      // FIXME: Add current playlist config save and load.
      final currentPlaylistString =
          _configService.getString('CurrentPlaylist') ?? '';
      final currentPlaylist =
          _libraryService.findPlaylistByTableName(currentPlaylistString);
      // _libraryService
      if (currentPlaylist.tableName.isNotEmpty) {
        final content = _libraryService.findPlayContent(currentMedia.path);
        if (content != null) {
          await setCurrentContent(content, currentPlaylist);
        }
      }
    }
    playMode = _configService.getString('PlayMode') ?? _repeatString;
    await switchPlayMode(playMode);
    return this;
  }

  /// Change current playing audio to given [playContent], and current playing
  /// list to [playlist].
  Future<void> setCurrentContent(
    PlayContent playContent,
    PlaylistModel playlist,
  ) async {
    await _setCurrentPathWithSave(playContent, playlist);
    // Clear play history no matter in shuffle play mode or not,
    // because the caller is a "play xxx audio" action.
    playHistoryList.clear();
    // If in shuffle mode, record [playContent] as the history head.
    if (playMode == _shuffleString) {
      playHistoryList.add(playContent);
    }
  }

  /// Set current playing audio to given [PlayContent]
  /// and do not clean play history.
  Future<void> _setCurrentPathWithSave(
    PlayContent playContent,
    PlaylistModel playlist,
  ) async {
    // Save scaled album cover in file for the just_audio_background service to
    // display on android control center.
    final hasCoverImage = playContent.albumCover.isNotEmpty;
    late final File coverFile;
    if (hasCoverImage) {
      final tmpDir = await getTemporaryDirectory();
      // FIXME: Clear cover cache.
      coverFile = File(
        '${tmpDir.path}/cover.cache.${DateTime.now().microsecondsSinceEpoch.toString()}',
      );
      await coverFile.writeAsBytes(
        base64Decode(playContent.albumCover),
        flush: true,
      );
    }
    // Read the full album cover image to display in music page.
    final p = await Get.find<MetadataService>().readMetadata(
      playContent.contentPath,
      loadImage: true,
      scaleImage: false,
    );
    currentContent.value = p;
    currentPlaylist = playlist;
    await _player.setSourceDeviceFile(p.contentPath);
    if (GetPlatform.isMobile) {
      await wrapper!.updateQueue([
        MediaItem(
          id: p.contentPath,
          title: p.title.isEmpty ? p.contentName : p.title,
          artist: p.artist,
          album: p.albumTitle,
          duration: Duration(seconds: p.length),
          artUri: hasCoverImage ? coverFile.uri : null,
        ),
      ]);
    }
    await _configService.saveString(
      'CurrentMedia',
      currentContent.value.contentPath,
    );
    await _configService.saveString(
      'CurrentPlaylist',
      currentPlaylist.tableName,
    );
    currentContent.value = p;
  }

  /// Start play.
  Future<void> play() async {
    // Use for debugging.
    // await _player.seek(Duration(seconds: (_player.duration!.inSeconds * 0.98)
    // .toInt()));
    await _player.resume();
  }

  /// Play when paused, pause when playing.
  Future<void> playOrPause() async {
    if (_player.state == PlayerState.playing) {
      await _player.pause();
      return;
    } else if (currentContent.value.contentPath.isNotEmpty) {
      await _player.resume();
      return;
    } else {
      // Not a good state.
    }
  }

  /// Change play mode.
  Future<void> switchPlayMode([String? mode]) async {
    if (mode != null) {
      if (mode == _repeatString) {
        playModeIcon.value = _repeatIcon;
        playMode = _repeatString;
        return;
      } else if (mode == _repeatOneString) {
        playModeIcon.value = _repeatOneIcon;
        playMode = _repeatOneString;
        return;
      } else if (mode == _shuffleString) {
        playModeIcon.value = _shuffleIcon;
        playMode = _shuffleString;
        return;
      }
    }
    if (playModeIcon.value == _repeatIcon) {
      playModeIcon.value = _repeatOneIcon;
      await _configService.saveString('PlayMode', _repeatOneString);
      playMode = _repeatOneString;
    } else if (playModeIcon.value == _repeatOneIcon) {
      playModeIcon.value = _shuffleIcon;
      await _configService.saveString('PlayMode', _shuffleString);
      playMode = _shuffleString;
    } else {
      playModeIcon.value = _repeatIcon;
      await _configService.saveString('PlayMode', _repeatString);
      playMode = _repeatString;
    }
  }

  /// Seek to another audio content.
  Future<void> seekToAnother(bool isNext) async {
    if (isNext) {
      switch (playMode) {
        case _shuffleString:
          if (playHistoryList.isNotEmpty) {
            for (var i = 0; i < playHistoryList.length; i++) {
              if (playHistoryList[i].contentPath ==
                      currentContent.value.contentPath &&
                  i < playHistoryList.length - 1) {
                await _setCurrentPathWithSave(
                  playHistoryList[i + 1],
                  currentPlaylist,
                );
                return;
              }
            }
          }
          final c = currentPlaylist.randomPlayContent();
          if (c.contentPath.isEmpty) {
            await play();
            return;
          }
          await _setCurrentPathWithSave(c, currentPlaylist);
          playHistoryList.add(c);
          // For test
          // final d = await _player.load();
          // if (d != null) {
          //   await _player.seek(Duration(seconds: d.inSeconds - 3));
          // }
          await play();
          break;
        case _repeatString:
        case _repeatOneString:
        default:
          final content = currentPlaylist.findNextContent(currentContent.value);
          if (content.contentPath.isEmpty) {
            return;
          }
          await setCurrentContent(content, currentPlaylist);
          // For test
          // final d = await _player.load();
          // if (d != null) {
          //   await _player.seek(Duration(seconds: d.inSeconds - 3));
          // }
          await play();
      }
    } else {
      switch (playMode) {
        case _shuffleString:
          if (playHistoryList.isNotEmpty) {
            for (var i = 0; i < playHistoryList.length; i++) {
              if (playHistoryList[i].contentPath ==
                      currentContent.value.contentPath &&
                  i > 0) {
                await _setCurrentPathWithSave(
                  playHistoryList[i - 1],
                  currentPlaylist,
                );
                return;
              }
            }
          }
          final c = currentPlaylist.randomPlayContent();
          if (c.contentPath.isEmpty) {
            await play();
            return;
          }
          await _setCurrentPathWithSave(c, currentPlaylist);
          playHistoryList.insert(0, c);
          await play();
          break;
        case _repeatString:
        case _repeatOneString:
        default:
          final content =
              currentPlaylist.findPreviousContent(currentContent.value);
          if (content.contentPath.isEmpty) {
            return;
          }
          await setCurrentContent(content, currentPlaylist);
          await play();
      }
    }
  }

  /// Jump to given [duration].
  Future<void> seekToDuration(Duration duration) async {
    await _player.seek(duration);
  }

  /// Return current curation.
  Future<Duration?> playerDuration() => _player.getDuration();
}
