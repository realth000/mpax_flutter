import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, Type> configMap = <String, Type>{
  "CurrentMedia": String,
};

class PlayerService extends GetxService {
  PlayerService() {
    init();
  }

  // State
  static const IconData _playIcon = Icons.play_arrow;
  static const IconData _pauseIcon = Icons.pause;
  static const IconData _repeatIcon = Icons.repeat;
  static const IconData _repeatOneIcon = Icons.repeat_one;
  static const IconData _shuffleIcon = Icons.shuffle;

  late final SharedPreferences _config;
  static final Map _configMap = Map.from(configMap);
  final _player = AudioPlayer();
  PlayContent content = PlayContent();

  // Show on media widget.
  Rx<String> titleText = "".obs;
  Rx<String> artistText = "".obs;
  Rx<String> albumText = "".obs;
  Rx<IconData> playButtonIcon = _playIcon.obs;
  Rx<IconData> playModeIcon = _repeatIcon.obs;

  Future<PlayerService> init() async {
    _config = await SharedPreferences.getInstance();
    _configMap['CurrentMedia'] = _config.getString('CurrentMedia');
    return this;
  }

  void play(PlayContent playContent) {
    final File f = File(playContent.contentPath);
    if (!f.existsSync()) {
      print("!! PlayerService::play: FIle not exists: ${f.path}");
      // Not exists
      return;
    }
    _player.setFilePath(playContent.contentPath);
    print("!! PlayerService::play: start play");
    _player.play();
    content = playContent;
    titleText.value =
        content.title.isEmpty ? content.contentName : content.title;
    artistText.value = content.artist.isEmpty ? "Unknown".tr : content.artist;
    albumText.value = content.albumTitle.isEmpty
        ? path.dirname(content.contentPath)
        : content.albumTitle;
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

  void switchPlayMode() {
    if (playModeIcon.value == _repeatIcon) {
      playModeIcon.value = _repeatOneIcon;
      return;
    } else if (playModeIcon.value == _repeatOneIcon) {
      playModeIcon.value = _shuffleIcon;
      return;
    } else {
      playModeIcon.value = _repeatIcon;
    }
  }
}
