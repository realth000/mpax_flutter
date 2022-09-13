import 'dart:io';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, Type> configMap = <String, Type>{
  "CurrentMedia": String,
};

class PlayerService extends GetxService {
  PlayerService() {
    init();
  }

  late final SharedPreferences _config;
  static final Map _configMap = Map.from(configMap);
  final _player = AudioPlayer();

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
  }
}
