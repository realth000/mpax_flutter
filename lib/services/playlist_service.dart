import 'package:get/get.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';

class PlaylistInfo {
  PlaylistInfo(this.name, this.needScan);

  final String name;
  final bool needScan;
}

class PlaylistService extends GetxService {
  final _libraryService = Get.find<MediaLibraryService>();
  final _allPlaylist = <PlaylistModel>[].obs;

  get allPlaylist => _allPlaylist.value;

  Future<void> addPlaylist(PlaylistInfo info) async {
    if (info.name.isEmpty) {
      return;
    }
    PlaylistModel playlist = PlaylistModel();
    playlist.name = info.name;
    _allPlaylist.add(playlist);
    await _libraryService.savePlaylist(playlist);
  }

  Future<PlaylistService> init() async {
    _allPlaylist.value = _libraryService.playlistModel;
    return this;
  }
}
