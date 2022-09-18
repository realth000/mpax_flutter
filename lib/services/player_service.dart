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

  // Current playing playlist.
  PlaylistModel currentPlaylist = PlaylistModel();

  // Current playing content.
  final currentContent = PlayContent().obs;

  // Show on media widget.
  Rx<IconData> playButtonIcon = _playIcon.obs;
  Rx<IconData> playModeIcon = _repeatIcon.obs;

  Future<PlayerService> init() async {
    // Load configs.
    final File currentMedia =
        File(_configService.getString('CurrentMedia') ?? "");
    if (currentMedia.existsSync()) {
      // FIXME: Add current playlist config save and load.
      final String currentPlaylistString =
          _configService.getString('CurrentPlaylist') ?? "";
      final PlaylistModel currentPlaylist =
          _libraryService.findPlaylistByTableName(currentPlaylistString);
      // _libraryService
      if (currentPlaylist.tableName.isNotEmpty) {
        setCurrentContent(PlayContent.fromEntry(currentMedia), currentPlaylist);
      }
    }
    switchPlayMode(_configService.getString('PlayMode') ?? _repeatString);
    return this;
  }

  void setCurrentContent(PlayContent playContent, PlaylistModel playlist) {
    final File f = File(playContent.contentPath);
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

  void play() {
    _player.play();
    playButtonIcon.value = _pauseIcon;
  }

  void playOrPause() {
    if (_player.playerState.playing) {
      _player.pause();
      playButtonIcon.value = _playIcon;
      return;
    } else if (currentContent.value.contentPath.isNotEmpty) {
      _player.play();
      playButtonIcon.value = _pauseIcon;
      return;
    } else {
      // Not a good state.
    }
  }

  void switchPlayMode([String? mode]) {
    if (mode != null) {
      if (mode == _repeatString) {
        playModeIcon.value = _repeatIcon;
        return;
      } else if (mode == _repeatOneString) {
        playModeIcon.value == _repeatOneIcon;
        return;
      } else if (mode == _shuffleString) {
        playModeIcon.value == _shuffleIcon;
        return;
      }
    }
    if (playModeIcon.value == _repeatIcon) {
      playModeIcon.value = _repeatOneIcon;
      _player.setLoopMode(LoopMode.one);
      _player.setShuffleModeEnabled(false);
      _configService.saveString("PlayMode", _repeatOneString);
    } else if (playModeIcon.value == _repeatOneIcon) {
      playModeIcon.value = _shuffleIcon;
      _player.setLoopMode(LoopMode.off);
      _player.setShuffleModeEnabled(true);
      _configService.saveString("PlayMode", _shuffleString);
    } else {
      playModeIcon.value = _repeatIcon;
      _player.setLoopMode(LoopMode.all);
      _player.setShuffleModeEnabled(false);
      _configService.saveString("PlayMode", _repeatString);
    }
  }

  void switchToSiblingMedia(bool isNext) {
    if (isNext) {
      PlayContent content =
          currentPlaylist.findNextContent(currentContent.value);
      if (content.contentPath.isEmpty) {
        return;
      }
      _player.setFilePath(content.contentPath);
      currentContent.value = content;
      play();
    } else {
      PlayContent content =
          currentPlaylist.findPreviousContent(currentContent.value);
      if (content.contentPath.isEmpty) {
        return;
      }
      _player.setFilePath(content.contentPath);
      currentContent.value = content;
      play();
    }
  }
}
