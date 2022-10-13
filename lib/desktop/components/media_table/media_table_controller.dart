import 'package:get/get.dart';

import '../../../models/play_content.model.dart';
import '../../../models/playlist.model.dart';
import '../../../services/media_library_service.dart';
import '../../../services/player_service.dart';

/// Controller of MediaTable.
///
/// Also handle interactive actions from UI with backend services.
/// Including play audio, switch audio, open files, and others.
/// This controller does not become a service because that MediaTable is more
/// one, being a service and refresh different tables is not efficient.
class MediaTableController extends GetxController {
  /// Constructor.
  MediaTableController();

  /// Whether to show filters.
  final showFiltersRow = false.obs;

  final _playerService = Get.find<PlayerService>();
  final _libraryService = Get.find<MediaLibraryService>();

  /// Return a sorted [PlaylistModel] with [sort] order in [column].
  Future<PlaylistModel> sort(
    PlaylistModel playlist,
    String column,
    String sort,
  ) async {
    final p = await _libraryService.sortPlaylist(playlist, column, sort);
    // If current playlist is in the table, to ensure update sort, update the
    // [currentPlaylist] in [PlayerService].
    // Otherwise the next or previous audio is wrong.
    // But do not update if current playing playlist is not the one in table.
    if (_playerService.currentPlaylist.tableName == p.tableName) {
      _playerService.currentPlaylist = p;
    }
    await _libraryService.savePlaylist(p);
    return p;
  }

  /// Require [PlayerService] to play specified [content].
  ///
  /// Call may from a double-click on MediaTable, MediaTable item context menu
  /// request or some other thing.
  Future<void> playAudio(PlayContent? content, PlaylistModel playlist) async {
    if (content == null) {
      return;
    }
    await _playerService.setCurrentContent(content, playlist);
    await _playerService.play();
  }
}
