import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/media_list.dart';

class PlaylistContentPage extends StatelessWidget {
  PlaylistContentPage({super.key});

  final playlist = Get.find<MediaLibraryService>()
      .findPlaylistByTableName(Get.parameters['playlist_table_name'] ?? '');

  String _wrapPlaylistName() {
    if (playlist.tableName == MediaLibraryService.allMediaTableName) {
      return 'Library'.tr;
    }
    return playlist.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: _wrapPlaylistName(),
      ),
      bottomNavigationBar: const MPaxPlayerWidget(),
      drawer: const MPaxDrawer(),
      body: MediaList(playlist),
    );
  }
}
