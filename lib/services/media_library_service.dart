import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';

class MediaLibraryService extends GetxService {
  List<PlaylistModel> _playlistModel = <PlaylistModel>[];
  PlaylistModel _allContentModel =
      PlaylistModel("MEDIA_ALL", "uninit_table", <PlayContent>[]);

  PlaylistModel get allContentModel => _allContentModel;

  // Used for prevent same name playlist.
  String _lastTimeStamp = "";
  int _lastCount = 0;

  List<PlayContent> get content => _allContentModel.contentList;

  bool addContent(PlayContent playContent) {
    if (_allContentModel.contentList.contains(playContent)) {
      return false;
    }
    _allContentModel.contentList.add(playContent);
    return true;
  }

  Future<void> generatePlaylist() async {
    await _allContentModel.generatePlaylist();
  }

  void resetLibrary() {
    _allContentModel.contentList.clear();
    _resetPlaylistModel(_allContentModel);
  }

  void _resetPlaylistModel(PlaylistModel model) {
    model.clearContent();
    model.tableName = _regenerateTableName();
    // print("!! GENERATED TABLE NAME ${model.tableName}");
  }

  Future<MediaLibraryService> init() async {
    // Load audio from storage (SQLite?)
    return this;
  }

  // As utils
  String _regenerateTableName() {
    final timeStamp = DateTime.now().microsecondsSinceEpoch.toString();
    if (timeStamp == _lastTimeStamp) {
      _lastCount++;
    } else {
      _lastTimeStamp = timeStamp;
      _lastCount = 0;
    }
    return "playlist_${timeStamp}_${_lastCount}_table";
  }
}
