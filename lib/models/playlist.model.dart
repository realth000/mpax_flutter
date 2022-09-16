import 'package:mpax_flutter/models/play_content.model.dart';

class PlaylistModel {
  PlaylistModel(this.name, this.tableName, this.contentList);

  String name;
  String tableName;
  List<PlayContent> contentList;

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
    for (int i = contentList.length - 1; i > -1; i--) {
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
    for (int i = 0; i < contentList.length; i++) {
      if (contentList[i].contentPath == playContent.contentPath) {
        return contentList[i + 1];
      }
    }
    return contentList.first;
  }
}
