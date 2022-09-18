import 'dart:math';

import 'package:mpax_flutter/models/play_content.model.dart';

class PlaylistModel {
  PlaylistModel();

  PlaylistModel.fromInfo(this.name, this.tableName, this.contentList);

  String name = '';
  String tableName = '';
  List<PlayContent> contentList = <PlayContent>[];
  static int id = -1;

  void clearContent() {
    contentList.clear();
  }

  PlayContent findPreviousContent(PlayContent playContent) {
    if (contentList.isEmpty) {
      return PlayContent();
    }
    if (contentList.first.contentPath == playContent.contentPath) {
      return contentList.last;
    }
    for (var i = contentList.length - 1; i > -1; i--) {
      if (contentList[i].contentPath == playContent.contentPath) {
        return contentList[i - 1];
      }
    }
    return contentList.first;
  }

  PlayContent findNextContent(PlayContent playContent) {
    if (contentList.isEmpty) {
      return PlayContent();
    }
    if (contentList.last.contentPath == playContent.contentPath) {
      return contentList.first;
    }
    for (var i = 0; i < contentList.length; i++) {
      if (contentList[i].contentPath == playContent.contentPath) {
        return contentList[i + 1];
      }
    }
    return contentList.first;
  }

  Map<String, dynamic> toMap() {
    id++;
    return {
      'id': id,
      'sort': contentList.length,
      'playlist_name': name,
      'table_name': tableName,
    };
  }

  PlayContent randomPlayContent() {
    if (contentList.isEmpty) {
      return PlayContent();
    }
    return contentList[Random().nextInt(contentList.length)];
  }
}
