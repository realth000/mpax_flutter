import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/scan_target_controller.dart';
import '../../../models/playlist_model.dart';
import '../../../services/media_library_service.dart';
import '../../../widgets/add_playlist_widget.dart';
import '../../../widgets/util_widgets.dart';
import '../../components/media_table/media_table_controller.dart';
import '../../components/media_table/media_table_view.dart';
import 'playlist_page_controller.dart';

/// Desktop playlist page, in main scaffold.
class DesktopPlaylistPage extends StatelessWidget {
  /// Constructor.
  DesktopPlaylistPage({super.key});

  final _controller = Get.put(DesktopPlaylistPageController());
  final _libraryService = Get.find<MediaLibraryService>();

  Widget _getPlaylistCover(Playlist model) {
    // TODO: Get first media audio cover here.
    if (model.musicList.isEmpty) {
      return const Icon(Icons.queue_music);
    } else {
      return const Icon(Icons.featured_play_list);
    }
  }

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
      await _libraryService.savePlaylist(playlistModel);
    }
    final tableController = Get.find<MediaTableController>();
    // Refresh playlist table if current playlist is arg playlistModel.
    // TODO: Make this not ugly.
    // if (playlistModel.tableName == tableController.playlist.value.tableName) {
    //   _controller.currentPlaylist.value = PlaylistModel();
    //   _controller.currentPlaylist.value =
    //       _libraryService.findPlaylistByTableName(playlistModel.tableName);
    // }
  }

  Widget _buildPlaylistView() {
    final lists = <ListTile>[];
    for (final model in _libraryService.allPlaylist) {
      // if (i == 0) {
      //   i++;
      //   continue;
      // }
      lists.add(
        ListTile(
          hoverColor: Colors.transparent,
          leading: _getPlaylistCover(model),
          title: Text(model.name),
          trailing: PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuItem<int>>[
              PopupMenuItem<int>(value: 0, child: Text('Add audio'.tr)),
              PopupMenuItem<int>(value: 1, child: Text('Rename'.tr)),
              PopupMenuItem<int>(value: 2, child: Text('Delete'.tr)),
            ],
            onSelected: (index) async {
              switch (index) {
                case 0:
                  await _addAudioByScanning(model);
                  break;
                case 1:
                  break;
                case 2:
                  await _libraryService.removePlaylist(model);
                  // When going to delete current showing playlist, delete it.
                  final currentShowingPlaylist =
                      Get.find<DesktopPlaylistPageController>().currentPlaylist;
                  // TODO: Delete selected playlist here.
                  // if (model.tableName ==
                  //     currentShowingPlaylist.value.tableName) {
                  //   currentShowingPlaylist.value = PlaylistModel();
                  // }
                  break;
                default:
                  break;
              }
            },
          ),
          onTap: () {
            // TODO: Update current playlist here.
            // _controller.currentPlaylist.value =
            // _libraryService.findPlaylistByTableName(model.tableName);
          },
        ),
      );
    }
    return ListView(
      itemExtent: 50,
      children: lists,
    );
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 200,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TitleText(
                            title: 'Playlist'.tr,
                            level: 1,
                          ),
                          IconButton(
                            onPressed: () async {
                              final name =
                                  await Get.dialog(AddPlaylistWidget());
                              if (name == null) {
                                return;
                              }
                              final p = Playlist()..name = name;
                              await _libraryService.addPlaylist(p);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: Obx(
                          () => _buildPlaylistView(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(() => MediaTable(_controller.currentPlaylist.value)),
            ),
          ),
        ],
      );
}
