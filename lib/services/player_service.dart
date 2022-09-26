import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';

class PlayerService extends GetxService {
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
  late Stream<Duration> positionStream = _player.positionStream;

  // Current playing playlist.
  PlaylistModel currentPlaylist = PlaylistModel();

  // Current playing content.
  final currentContent = PlayContent().obs;
  String playMode = _repeatString;

  // Show on media widget.
  Rx<IconData> playButtonIcon = _playIcon.obs;
  Rx<IconData> playModeIcon = _repeatIcon.obs;

  // late final StreamSubscription<ProcessingState> _playerDurationStream;

  // void dispose() {
  //   _playerDurationStream.cancel();
  //   print("DISPOSE!!!!!");
  // }

  Future<PlayerService> init() async {
    await _player.setShuffleModeEnabled(false);
    await _player.setLoopMode(LoopMode.off);
    _player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        if (playMode == _repeatOneString) {
          if (_player.playing) {
            await _player.seek(Duration.zero);
          }
          _player.play();
        } else {
          await seekToAnother(true);
        }
      }
    });
    // Load configs.
    final File currentMedia =
        File(_configService.getString('CurrentMedia') ?? '');
    if (currentMedia.existsSync()) {
      // FIXME: Add current playlist config save and load.
      final String currentPlaylistString =
          _configService.getString('CurrentPlaylist') ?? '';
      final PlaylistModel currentPlaylist =
          _libraryService.findPlaylistByTableName(currentPlaylistString);
      // _libraryService
      if (currentPlaylist.tableName.isNotEmpty) {
        await setCurrentContent(
            PlayContent.fromEntry(currentMedia), currentPlaylist);
      }
    }
    playMode = _configService.getString('PlayMode') ?? _repeatString;
    await switchPlayMode(playMode);
    return this;
  }

  Future<void> setCurrentContent(
      PlayContent playContent, PlaylistModel playlist) async {
    final f = File(playContent.contentPath);
    if (!f.existsSync()) {
      // Not exists
      return;
    }
    currentContent.value = playContent;
    currentPlaylist = playlist;
    await _player
        .setAudioSource(AudioSource.uri(Uri.parse(playContent.contentPath)));
    _configService.saveString('CurrentMedia', currentContent.value.contentPath);
    _configService.saveString('CurrentPlaylist', currentPlaylist.tableName);
    currentContent.value = playContent;
  }

  Future<void> play() async {
    // FIXME: The first time from MediaListTileItem to here not finishes .play(),
    // To turn the icon, assign before .play().
    playButtonIcon.value = _pauseIcon;
    await _player.load();
    // Use for debugging.
    // await _player.seek(Duration(seconds: (_player.duration!.inSeconds * 0.98).toInt()));
    await _player.play();
  }

  Future<void> playOrPause() async {
    if (_player.playerState.playing) {
      await _player.pause();
      playButtonIcon.value = _playIcon;
      return;
    } else if (currentContent.value.contentPath.isNotEmpty) {
      playButtonIcon.value = _pauseIcon;
      await _player.play();
      return;
    } else {
      // Not a good state.
    }
  }

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
      _configService.saveString('PlayMode', _repeatOneString);
      playMode = _repeatOneString;
    } else if (playModeIcon.value == _repeatOneIcon) {
      playModeIcon.value = _shuffleIcon;
      _configService.saveString('PlayMode', _shuffleString);
      playMode = _shuffleString;
    } else {
      playModeIcon.value = _repeatIcon;
      _configService.saveString('PlayMode', _repeatString);
      playMode = _repeatString;
    }
  }

  Future<void> seekToAnother(bool isNext) async {
    if (isNext) {
      switch (playMode) {
        case _shuffleString:
          PlayContent c = currentPlaylist.randomPlayContent();
          if (c.contentPath.isEmpty) {
            await play();
            return;
          }
          await setCurrentContent(c, currentPlaylist);
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
          var content = currentPlaylist.findNextContent(currentContent.value);
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
        // TODO: Use history here.
        case _shuffleString:
          var c = currentPlaylist.randomPlayContent();
          if (c.contentPath.isEmpty) {
            await play();
            return;
          }
          await setCurrentContent(c, currentPlaylist);
          await play();
          break;
        case _repeatString:
        case _repeatOneString:
        default:
          var content =
              currentPlaylist.findPreviousContent(currentContent.value);
          if (content.contentPath.isEmpty) {
            return;
          }
          await setCurrentContent(content, currentPlaylist);
          await play();
      }
    }
  }

  Duration? playerDuration() {
    return _player.duration;
  }
}
