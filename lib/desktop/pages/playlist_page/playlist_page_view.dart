import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/playlist.model.dart';
import '../../../services/media_library_service.dart';
import '../../../utils/scan_target_controller.dart';
import '../../../widgets/util_widgets.dart';
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
            _controller.currentPlaylist.value =
                _libraryService.findPlaylistByTableName(model.tableName);
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
              padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
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
                                  await Get.dialog(_AddPlaylistWidget());
                              if (name == null) {
                                return;
                              }
                              final p = PlaylistModel()..name = name;
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

// TODO: Duplicate with _AddPlaylistWidget in playlist_page.dart.
class _AddPlaylistWidget extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Form _askForm() => Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name'.tr,
                hintText: 'Input name'.tr,
              ),
              validator: (v) =>
                  v!.trim().isNotEmpty ? null : 'Name can not be empty'.tr,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState == null ||
                          !(_formKey.currentState!).validate()) {
                        return;
                      }
                      Get.back(result: _nameController.text);
                    },
                    child: Text('OK'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => ModalDialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 10,
            children: <Widget>[
              Text(
                'Add Playlist'.tr,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              _askForm(),
            ],
          ),
        ),
      );
}
