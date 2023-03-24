import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/music_model.dart';
import '../../../models/playlist_model.dart';
import '../../../services/media_library_service.dart';
import '../../../services/player_service.dart';

/// Icons.play_arrow
final playingIcon = String.fromCharCode(Icons.play_arrow.codePoint);

/// Controller of MediaTable.
///
/// Also handle interactive actions from UI with backend services.
/// Including play audio, switch audio, open files, and others.
/// This controller does not become a service because that MediaTable is more
/// one, being a service and refresh different tables is not efficient.
class MediaTableController extends GetxController {
  /// Constructor.
  MediaTableController(PlaylistModel playlist) {
    this.playlist.value = playlist;
  }

  /// Whether to show filters.
  final showFiltersRow = false.obs;

  /// Current playing audio's filePath.
  ///
  /// If changed, set the same content row in [MediaTable] state to "playing".
  /// If required "scroll table to current playing content", also find that
  /// content by this file path.
  final currentPlayingContent = ''.obs;

  /// Playlist in this table.
  final playlist = PlaylistModel().obs;

  final _playerService = Get.find<PlayerService>();
  final _libraryService = Get.find<MediaLibraryService>();

  /// Save table's [PlutoGridStateManager].
  ///
  /// Didn't want to do this but no other solutions.
  late PlutoGridStateManager? tableStateManager;

  /// Return a sorted [PlaylistModel] with [sort] order in [column].
  Future<PlaylistModel> sort(
    PlaylistModel playlist,
    String column,
    String sort,
  ) async {
    // final p = await _libraryService.sortPlaylist(playlist, column, sort);
    // If current playlist is in the table, to ensure update sort, update the
    // [currentPlaylist] in [PlayerService].
    // Otherwise the next or previous audio is wrong.
    // But do not update if current playing playlist is not the one in table.
    // FIXME: Check current playlist here.
    // if (_playerService.currentPlaylist.tableName == p.tableName) {
    //   _playerService.currentPlaylist = p;
    // }
    // await _libraryService.savePlaylist(p);
    // return p;
    return PlaylistModel();
  }

  /// Require [PlayerService] to play specified [content].
  ///
  /// Call may from a double-click on MediaTable, MediaTable item context menu
  /// request or some other thing.
  Future<void> playAudio(Music? content, PlaylistModel playlist) async {
    if (content == null) {
      return;
    }
    await _playerService.setCurrentContent(content, playlist);
    await _playerService.play();
  }

  @override
  void onInit() {
    super.onInit();
    // When current playing audio changes, update currentPlayingContent to
    // notify UI to change state icon.
    _playerService.currentContent.listen((content) {
      currentPlayingContent.value = content.filePath;
    });
    ever(playlist, (_) => checkedRowPathList.value.clear());
    // When current playing audio changes, update the state icon in table.
    // This means:
    // The current playing audio (specified by audio file path, as named,
    // contentPath) should have a "playing" state sign in "state" column.
    // Other audios should not have "playing" state sign.
    //
    // Use "debounce" to set a delay, prevent high frequency of resetting.
    debounce(
      currentPlayingContent,
      (contentPath) => {
        if (tableStateManager != null)
          {
            for (final row in tableStateManager!.rows)
              {
                row.cells['state']!.value =
                    row.cells['path']!.value == contentPath ? playingIcon : '',
              },
            refreshTable(),
          }
      },
      time: const Duration(milliseconds: 300),
    );
  }

  /// Whether the column filters in audio table is visible.
  final searchEnabled = false.obs;

  /// Record all checked row's file path in table.
  ///
  /// When using [checkedRowPathList], use with '.value', otherwise the UI table
  /// can not update.
  /// e.g. _controller.checkedRowPathList.value
  final checkedRowPathList = <String>[].obs;

  /// Call table's [PlutoGridStateManager] to refresh table data.
  void refreshTable() {
    if (tableStateManager == null) {
      return;
    }
    tableStateManager!.notifyListeners();
  }
}
