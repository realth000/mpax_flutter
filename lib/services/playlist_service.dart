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
    // FIXME: Maybe should do in MediaLibraryService.
    // _libraryService.addPlaylist(playlist);
    _allPlaylist.add(playlist);
    await _libraryService.savePlaylist(playlist);
  }

  Future<void> deletePlaylist(PlaylistModel playlistModel) async {
    _allPlaylist.remove(playlistModel);
    // TODO: There should be something like .removePlaylist,
    // instead of rewriting the whole database.
    await _libraryService.saveAllPlaylist();
  }

  Future<PlaylistService> init() async {
    _allPlaylist.value = _libraryService.playlistModel;
    return this;
  }

  Future<void> savePlaylist(PlaylistModel playlistModel) async {
    await _libraryService.savePlaylist(playlistModel);
  }
}
