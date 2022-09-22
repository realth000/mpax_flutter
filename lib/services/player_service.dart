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
  late final StreamSubscription<Duration?> _playerDurationStream;

  // void dispose() {
  //   _playerDurationStream.cancel();
  //   print("DISPOSE!!!!!");
  // }

  Future<PlayerService> init() async {
    _playerDurationStream = _player.positionStream.listen((position) async {
      if (position == _player.duration) {
        await seekToAnother(true);
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
        setCurrentContent(PlayContent.fromEntry(currentMedia), currentPlaylist);
      }
    }
    playMode = _configService.getString('PlayMode') ?? _repeatString;
    await switchPlayMode(playMode);
    return this;
  }

  void setCurrentContent(PlayContent playContent, PlaylistModel playlist) {
    final f = File(playContent.contentPath);
    if (!f.existsSync()) {
      // Not exists
      return;
    }
    currentContent.value = playContent;
    currentPlaylist = playlist;
    _player.setFilePath(playContent.contentPath);
    _configService.saveString('CurrentMedia', currentContent.value.contentPath);
    _configService.saveString('CurrentPlaylist', currentPlaylist.tableName);
    currentContent.value = playContent;
  }

  Future<void> play() async {
    await _player.play();
    playButtonIcon.value = _pauseIcon;
  }

  Future<void> playOrPause() async {
    if (_player.playerState.playing) {
      await _player.pause();
      playButtonIcon.value = _playIcon;
      return;
    } else if (currentContent.value.contentPath.isNotEmpty) {
      await _player.play();
      playButtonIcon.value = _pauseIcon;
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
        playModeIcon.value == _repeatOneIcon;
        playMode = _repeatOneString;
        return;
      } else if (mode == _shuffleString) {
        playModeIcon.value == _shuffleIcon;
        playMode = _shuffleString;
        return;
      }
    }
    if (playModeIcon.value == _repeatIcon) {
      playModeIcon.value = _repeatOneIcon;
      await _player.setLoopMode(LoopMode.one);
      await _player.setShuffleModeEnabled(false);
      _configService.saveString('PlayMode', _repeatOneString);
      playMode = _repeatOneString;
    } else if (playModeIcon.value == _repeatOneIcon) {
      playModeIcon.value = _shuffleIcon;
      await _player.setLoopMode(LoopMode.off);
      await _player.setShuffleModeEnabled(true);
      _configService.saveString('PlayMode', _shuffleString);
      playMode = _shuffleString;
    } else {
      playModeIcon.value = _repeatIcon;
      await _player.setLoopMode(LoopMode.all);
      await _player.setShuffleModeEnabled(false);
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
          setCurrentContent(c, currentPlaylist);
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
          _player.setFilePath(content.contentPath);
          currentContent.value = content;
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
          setCurrentContent(c, currentPlaylist);
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
          _player.setFilePath(content.contentPath);
          await play();
      }
    }
  }

  Duration? playerDuration() {
    return _player.duration;
  }
}
