import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/controllers/scan_target_controller.dart';
import 'package:mpax_flutter/mobile/components/mobile_underfoot.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/add_playlist_widget.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';

/// Playlist page, show all playlists.
class PlaylistPage extends GetView<MediaLibraryService> {
  /// Constructor.
  const PlaylistPage({super.key});

  Future<void> _addAudioByScanning(Playlist playlistModel) async {
    final targetPath = await FilePicker.platform.getDirectoryPath();
    if (targetPath == null) {
      return;
    }
    final scanner = AudioScanner(
      targetPath: targetPath,
      targetModel: playlistModel,
    );
    if (await scanner.scan() > 0) {
      await controller.savePlaylist(playlistModel);
    }
  }

  Widget _buildPlaylistMenu(Playlist playlistModel) => ModalDialog(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: Text('Add audio'.tr),
              onTap: () async {
                await _addAudioByScanning(playlistModel);
                Get.back<void>();
              },
            ),
            ListTile(
              leading: const Icon(Icons.drive_file_rename_outline),
              title: Text('Rename'.tr),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.playlist_remove),
              title: Text('Delete'.tr),
              onTap: () async {
                await controller.removePlaylist(playlistModel);
                Get.back<void>();
              },
            ),
          ],
        ),
      );

  Future<void> _openPlaylistMenu(Playlist playlistModel) async {
    await Get.dialog<void>(_buildPlaylistMenu(playlistModel));
  }

  Future<void> _addPlaylist() async {
    final name = await Get.dialog<String>(AddPlaylistWidget());
    if (name == null) {
      return;
    }
    final p = Playlist()..name = name;
    await controller.addPlaylist(p);
  }

  Widget _getPlaylistCover(Playlist model) {
    // TODO: Get first media audio cover here.
    // if (model.contentList.isEmpty) {
    //   return const Icon(Icons.queue_music);
    // } else {
    //   return const Icon(Icons.featured_play_list);
    // }
    return const Placeholder();
  }

  ListTile _buildPlaylistItem(Playlist model) => ListTile(
        leading: _getPlaylistCover(model),
        title: Text(model.name),
        trailing: IconButton(
          onPressed: () async => _openPlaylistMenu(model),
          icon: const Icon(Icons.menu),
        ),
        onTap: () async {
          // await Get.toNamed(
          //   MPaxRoutes.playlistContent
          //       .replaceFirst(':playlist_table_name', model.tableName),
          // );
        },
      );

  List<Widget> _buildPlaylistList() {
    final list = <Widget>[];
    for (final playlist in controller.allPlaylist) {
      list.add(_buildPlaylistItem(playlist));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: 'Playlist'.tr,
          actions: <Widget>[
            IconButton(
              onPressed: () async => _addPlaylist(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: const MPaxDrawer(),
        body: Obx(
          () => ListView(
            children: _buildPlaylistList(),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
      );
}
