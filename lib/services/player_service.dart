import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:path/path.dart' as path;

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
  final _player = AudioPlayer();
  PlayContent content = PlayContent();

  // Show on media widget.
  Rx<String> titleText = "".obs;
  Rx<String> artistText = "".obs;
  Rx<String> albumText = "".obs;
  Rx<IconData> playButtonIcon = _playIcon.obs;
  Rx<IconData> playModeIcon = _repeatIcon.obs;

  // Player widget properties.
  Offset startOffset = const Offset(0, 0);
  Rx<Alignment> infoAlignment = Alignment.centerLeft.obs;

  Future<PlayerService> init() async {
    // Load configs.
    final File currentMediaString =
        File(_configService.getString('CurrentMedia') ?? "");
    print('load currentMediaString:$currentMediaString');
    if (currentMediaString.existsSync()) {
      setCurrentContent(PlayContent.fromEntry(currentMediaString));
    }
    final playModeString =
        _configService.getString('PlayMode') ?? _repeatString;
    print('load play mode string:$playModeString');
    switch (playModeString) {
      case _repeatString:
        playModeIcon.value = _repeatIcon;
        break;
      case _repeatOneString:
        playModeIcon.value = _repeatOneIcon;
        break;
      case _shuffleString:
        playModeIcon.value = _shuffleIcon;
    }
    return this;
  }

  void setCurrentContent(PlayContent playContent) {
    final File f = File(playContent.contentPath);
    if (!f.existsSync()) {
      print("!! PlayerService::play: FIle not exists: ${f.path}");
      // Not exists
      return;
    }
    _player.setFilePath(playContent.contentPath);
    content = playContent;
    titleText.value =
        content.title.isEmpty ? content.contentName : content.title;
    artistText.value = content.artist.isEmpty ? "Unknown".tr : content.artist;
    albumText.value = content.albumTitle.isEmpty
        ? path.dirname(content.contentPath)
        : content.albumTitle;
  }

  void play() {
    _player.play();
    _configService.saveString('CurrentMedia', content.contentPath);
    print("SAVE CURRENT MEDIA:${content.contentPath}");
  }

  void playOrPause() {
    if (_player.playerState.playing) {
      _player.pause();
      playButtonIcon.value = _playIcon;
      return;
    } else if (content.contentPath.isNotEmpty) {
      _player.play();
      playButtonIcon.value = _pauseIcon;
      return;
    } else {
      // Not a good state.
    }
  }

  void switchPlayMode([String? mode]) {
    print("SAVE playmode");
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

  void recordDragStart(DragStartDetails details) {
    startOffset = details.globalPosition;
  }

  void updateDrag(DragUpdateDetails details) {
    Alignment s = Alignment(
        (details.globalPosition.dx - startOffset.dx) / startOffset.dx - 1, 0);
    if (s.x > 0 && s.x > infoAlignment.value.x) {
      infoAlignment.value = s;
    } else if (s.x < 0 && s.x < infoAlignment.value.x) {
      infoAlignment.value = s;
    }
    print('AAAA << ${infoAlignment.value.x}');
  }

  void checkDragEnd(DragEndDetails details) {
    if (infoAlignment.value.x > 0.7) {
      print('Play next ${infoAlignment.value.x} ${startOffset.dx}');
    } else if (infoAlignment.value.x < -1.2) {
      print('play pre ${infoAlignment.value.x} ${startOffset.dx}');
    }
    infoAlignment.value = Alignment.centerLeft;
  }
}
