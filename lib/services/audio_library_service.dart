import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';

class AudioLibraryService extends GetxService {
  AudioLibraryService() {
    init();
  }

  List<PlayContent> _contentList = <PlayContent>[];

  List<PlayContent> get content => _contentList;

  bool addContent(PlayContent playContent) {
    if (_contentList.contains(playContent)) {
      return false;
    }
    _contentList.add(playContent);
    return true;
  }

  Future<AudioLibraryService> init() async {
    // Load audio from storage (SQLite?)
    return this;
  }
}
