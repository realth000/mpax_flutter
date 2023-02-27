import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:get/get.dart';

import '../services/player_service.dart';

/// Lyric widget.
class LyricWidget extends StatelessWidget {
  /// Constructor.
  LyricWidget({super.key});

  final _playerService = Get.find<PlayerService>();

  final _lyricModelBuilder = LyricsModelBuilder.create();

  @override
  Widget build(BuildContext context) => Obx(
        () => LyricsReader(
          model: _lyricModelBuilder
              .bindLyricToMain(_playerService.currentContent.value.lyrics)
              .getModel(),
          position: _playerService.currentPosition.value.inMilliseconds,
          lyricUi: UINetease(),
          playing: true,
          emptyBuilder: () => Center(
            child: Text(
              'No lyrics'.tr,
              style: TextStyle(
                fontSize: 23,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
          selectLineBuilder: (progress, confirm) => Row(
            children: [
              Text(progress.toString()),
            ],
          ),
        ),
      );
}
