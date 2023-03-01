import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_widget.dart';
import 'package:get/get.dart';

import '../services/player_service.dart';

///Sample Netease style
///should be extends LyricUI implementation your own UI.
///this property only for change UI,if not demand just only overwrite methods.
class UINeteaseLight extends LyricUI {
  UINeteaseLight(
      {this.defaultSize = 18,
      this.defaultExtSize = 14,
      this.otherMainSize = 16,
      this.bias = 0.5,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlight = true,
      this.highlightDirection = HighlightDirection.LTR});

  UINeteaseLight.clone(UINetease uiNetease)
      : this(
          defaultSize: uiNetease.defaultSize,
          defaultExtSize: uiNetease.defaultExtSize,
          otherMainSize: uiNetease.otherMainSize,
          bias: uiNetease.bias,
          lineGap: uiNetease.lineGap,
          inlineGap: uiNetease.inlineGap,
          lyricAlign: uiNetease.lyricAlign,
          lyricBaseLine: uiNetease.lyricBaseLine,
          highlight: uiNetease.highlight,
          highlightDirection: uiNetease.highlightDirection,
        );
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.deepPurple[600], fontSize: defaultExtSize);

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.deepPurple[500],
        fontSize: defaultExtSize,
      );

  @override
  TextStyle getOtherMainTextStyle() =>
      TextStyle(color: Colors.deepPurple[400], fontSize: otherMainSize);

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
        color: Colors.deepPurple[600],
        fontSize: defaultSize,
      );

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;
}

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
          lyricUi: Theme.of(context).brightness == Brightness.dark
              ? UINetease(
                  defaultSize: 22,
                  highlight: false,
                )
              : UINeteaseLight(
                  defaultSize: 22,
                  highlight: false,
                ),
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
