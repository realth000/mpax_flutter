import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/play_content.model.dart';
import '../../../models/playlist.model.dart';
import '../../../services/media_library_service.dart';
import '../../../services/metadata_service.dart';
import '../../../widgets/add_playlist_widget.dart';
import '../../../widgets/util_widgets.dart';
import 'media_table_controller.dart';

/// Toolbar use in audio table, in the table header.
class MediaTableToolbar extends GetView<MediaTableController> {
  /// Constructor
  MediaTableToolbar({required this.stateManater, super.key});

  /// [PlutoGridStateManager] to apply state change.
  final PlutoGridStateManager stateManater;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => TitleText(title: controller.playlistName.value, level: 0),
          ),
          Row(
            children: [
              PopupMenuButton<int>(
                child: const Icon(Icons.list_alt),
                itemBuilder: (context) => <PopupMenuItem<int>>[
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('Add to new playlist'.tr),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text('Delete from list'.tr),
                  ),
                ],
                onSelected: (index) async {
                  if (index == 0) {
                    final name = await Get.dialog(AddPlaylistWidget());
                    if (name == null) {
                      return;
                    }
                    final list = <PlayContent>[];
                    for (final c in controller.checkedRowPathList) {
                      // list.add(PlayContent.fromPath(c));
                      list.add(
                        await Get.find<MetadataService>().readMetadata(
                          c,
                          loadImage: true,
                        ),
                      );
                    }
                    final p = PlaylistModel()
                      ..name = name
                      ..contentList = list;
                    await Get.find<MediaLibraryService>().addPlaylist(p);
                  } else if (index == 1) {
                    final currentPagePlaylist =
                        Get.find<MediaLibraryService>().findPlaylistByTableName(
                      controller.playlistTableName.value,
                    );
                    await currentPagePlaylist
                        .removeByPathList(controller.checkedRowPathList);
                    controller.checkedRowPathList.clear();
                    controller.tableStateManager?.notifyListeners();
                  }
                },
              ),
              const SizedBox(width: 10, height: 10),
              Text('Search'.tr),
              Obx(
                () => Switch(
                  value: controller.searchEnabled.value,
                  onChanged: (value) {
                    controller.searchEnabled.value = value;
                    stateManater.setShowColumnFilter(value);
                  },
                ),
              ),
            ],
          ),
        ],
      );
}
