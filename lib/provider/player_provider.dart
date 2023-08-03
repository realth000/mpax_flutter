import 'dart:typed_data';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_audio/simple_audio.dart';

part 'player_provider.g.dart';

class Player {
  final SimpleAudio _player = SimpleAudio();

  Future<void> play(String filePath,
      {String? title,
      String? artist,
      String? album,
      Uint8List? artwork}) async {
    await _player.stop();
    await _player.setMetadata(Metadata(
      title: title,
      artist: artist,
      album: album,
      artBytes: artwork,
    ));
    await _player.open(filePath);
    await _player.play();
  }

  Future<void> playOrPause() async {
    if (await _player.isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }
}

final _player = Player();

@Riverpod(keepAlive: true)
Player player(PlayerRef ref) => _player;
