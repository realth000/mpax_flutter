import 'package:mpax_flutter/models/play_content.model.dart';

class PlaylistModel {
  PlaylistModel(this.name, this.tableName, this.contentList);

  String name;
  String tableName;
  List<PlayContent> contentList;

  void clearContent() {
    contentList.clear();
  }
}
