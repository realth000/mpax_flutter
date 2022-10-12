import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/playlist.model.dart';
import '../../../services/media_library_service.dart';
import '../../../utils/scan_target_controller.dart';
import '../../components/media_table/media_table_view.dart';
import 'playlist_page_controller.dart';

/// Desktop playlist page, in main scaffold.
class DesktopPlaylistPage extends StatelessWidget {
  /// Constructor.
  DesktopPlaylistPage({super.key});

  final _controller = Get.put(DesktopPlaylistPageController());
  final _libraryService = Get.find<MediaLibraryService>();

  Widget _getPlaylistCover(PlaylistModel model) {
    // TODO: Get first media audio cover here.
    if (model.contentList.isEmpty) {
      return const Icon(Icons.queue_music);
    } else {
      return const Icon(Icons.featured_play_list);
    }
  }

  Future<void> _addAudioByScanning(PlaylistModel playlistModel) async {
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
                  break;
                default:
                  break;
              }
            },
          ),
          onTap: () {
            _controller.currentPlaylistTableName.value = model.tableName;
            _controller.currentPlaylist.value =
                _libraryService.findPlaylistByTableName(
              _controller.currentPlaylistTableName.value,
            );
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
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                    child: _buildPlaylistView(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Obx(
                () => MediaTable(
                  _controller.currentPlaylist.value,
                ),
              ),
            ),
          ),
        ],
      );
}
