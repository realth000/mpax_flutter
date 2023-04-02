import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/music_model.dart';
import '../../../widgets/add_playlist_widget.dart';
import '../../../widgets/util_widgets.dart';
import 'media_table_controller.dart';

enum _MenuOption {
  openOrCloseSearch,
  addToPlaylist,
  deleteFromPlaylist,
}

/// Toolbar use in audio table, in the table header.
class MediaTableToolbar extends GetView<MediaTableController> {
  /// Constructor
  const MediaTableToolbar({super.key});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => TitleText(
              title: controller.playlistName.value == 'all_media'
                  ? 'Library'.tr
                  : controller.playlistName.value,
              level: 0,
            ),
          ),
          Row(
            children: [
              PopupMenuButton<_MenuOption>(
                child: const Icon(Icons.menu),
                itemBuilder: (context) => <PopupMenuItem<_MenuOption>>[
                  PopupMenuItem<_MenuOption>(
                    value: _MenuOption.openOrCloseSearch,
                    child: Row(
                      children: [
                        Obx(
                          () => controller.searchEnabled.value
                              ? const Icon(Icons.search_off)
                              : const Icon(Icons.search),
                        ),
                        Text('Search'.tr),
                      ],
                    ),
                  ),
                  PopupMenuItem<_MenuOption>(
                    value: _MenuOption.addToPlaylist,
                    child: Row(
                      children: [
                        const Icon(Icons.add),
                        Text('Add to new playlist'.tr),
                      ],
                    ),
                  ),
                  PopupMenuItem<_MenuOption>(
                    value: _MenuOption.deleteFromPlaylist,
                    child: Row(
                      children: [
                        const Icon(Icons.delete),
                        Text('Delete from list'.tr),
                      ],
                    ),
                  ),
                ],
                onSelected: (index) async {
                  switch (index) {
                    case _MenuOption.openOrCloseSearch:
                      final state = !controller.searchEnabled.value;
                      controller.searchEnabled.value = state;
                      break;
                    case _MenuOption.addToPlaylist:
                      final name = await Get.dialog(AddPlaylistWidget());
                      if (name == null) {
                        return;
                      }
                      final list = <Music>[];
                      // TODO: Add to playlist here.
                      // for (final c in controller.checkedRowPathList) {
                      // list.add(PlayContent.fromPath(c));
                      // list.add(
                      //   await Get.find<MetadataService>().readMetadata(
                      //     c,
                      //     loadImage: true,
                      //   ),
                      // );
                      // }
                      // final p = PlaylistModel()
                      //   ..name = name
                      //   ..contentList = list;
                      // await Get.find<MediaLibraryService>().addPlaylist(p);
                      break;
                    case _MenuOption.deleteFromPlaylist:
                    // TODO: Delete from playlist here.
                    // final currentPagePlaylist =
                    //     Get.find<MediaLibraryService>()
                    //         .findPlaylistByTableName(
                    //   controller.playlist.value.tableName,
                    // );
                    // await currentPagePlaylist
                    //     .removeByPathList(controller.checkedRowPathList);
                    // controller.checkedRowPathList.clear();
                    // controller.tableStateManager?.notifyListeners();
                  }
                },
              ),
            ],
          ),
        ],
      );
}
