import 'package:flutter/material.dart';

enum PlayerState {
  Playing,
  Stop,
  Pause,
}

enum PlayMode {
  Repeat,
  RepeatOne,
  Shuffle,
}

const playerStateIconMap = <PlayerState, Icon>{
  PlayerState.Playing: Icon(Icons.pause),
  PlayerState.Stop: Icon(Icons.play_arrow),
  PlayerState.Pause: Icon(Icons.play_arrow),
};

const playModeIconMap = <PlayMode, Icon>{
  PlayMode.Repeat: Icon(Icons.repeat),
  PlayMode.RepeatOne: Icon(Icons.repeat_one),
  PlayMode.Shuffle: Icon(Icons.shuffle),
};
