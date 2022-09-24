import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/media_list_item.dart';

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
      body: _PlaylistBodyWidget(playlist: playlist),
    );
  }
}

class _PlaylistBodyWidget extends StatelessWidget {
  const _PlaylistBodyWidget({required this.playlist});

  final PlaylistModel playlist;

  List<Widget> _buildMediaList() {
    var list = <Widget>[];
    for (final playContent in playlist.contentList) {
      list.add(MediaItemTile(playContent, playlist));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: _buildMediaList(),
        ),
      ),
    );
  }
}
