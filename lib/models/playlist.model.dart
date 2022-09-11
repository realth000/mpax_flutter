import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';

class PlaylistModel {
  PlaylistModel(this.name, this.tableName, this.content);

  final String name;
  final String tableName;
  List<PlayContent> content;
}
