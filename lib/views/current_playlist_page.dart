import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/media_library_service.dart';
import '../widgets/app_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_player_widget.dart';
import '../widgets/media_list.dart';

/// Show audio contents in current playlist.
///
/// The 'Current' is given by caller.
class PlaylistContentPage extends StatelessWidget {
  /// Constructor.
  PlaylistContentPage({super.key});

  /// Current playlist, uses in switching audio.
  final playlist = Get.find<MediaLibraryService>()
      .findPlaylistByTableName(Get.parameters['playlist_table_name'] ?? '');

  String _wrapPlaylistName() {
    if (playlist.tableName == MediaLibraryService.allMediaTableName) {
      return 'Library'.tr;
    }
    return playlist.name;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: _wrapPlaylistName(),
        ),
        bottomNavigationBar: const MPaxPlayerWidget(),
        drawer: const MPaxDrawer(),
        body: MediaList(playlist),
      );
}
