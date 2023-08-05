import 'package:flutter/material.dart';

enum PlayerState {
  playing,
  stop,
  pause,
}

enum PlayMode {
  repeat,
  repeatOne,
  shuffle,
}

const playerStateIconMap = <PlayerState, Icon>{
  PlayerState.playing: Icon(Icons.pause),
  PlayerState.stop: Icon(Icons.play_arrow),
  PlayerState.pause: Icon(Icons.play_arrow),
};

const playModeIconMap = <PlayMode, Icon>{
  PlayMode.repeat: Icon(Icons.repeat),
  PlayMode.repeatOne: Icon(Icons.repeat_one),
  PlayMode.shuffle: Icon(Icons.shuffle),
};
