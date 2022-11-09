import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../mobile/components/mobile_underfoot.dart';
import '../routes/app_pages.dart';
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
          actions: <Widget>[
            IconButton(
              onPressed: () async => Get.toNamed(
                MPaxRoutes.search.replaceFirst(
                  ':playlist_table_name',
                  playlist.tableName,
                ),
              ),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
        drawer: const MPaxDrawer(),
        body: MediaList(playlist),
      );
}
