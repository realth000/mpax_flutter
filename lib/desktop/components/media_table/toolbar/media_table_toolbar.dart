import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/util_widgets.dart';
import 'media_table_toolbar_controller.dart';

/// Toolbar use in audio table, in the table header.
class MediaTableToolbar extends StatelessWidget {
  /// Constructor
  MediaTableToolbar({required this.stateManater, super.key});

  /// [PlutoGridStateManager] to apply state change.
  final PlutoGridStateManager stateManater;

  /// Control what widget to show in toolbar and toolbar state.
  final controller = Get.put(MediaTableToolbarController());

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
                    child: Text('Add to other playlist'.tr),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text('Delete from list'.tr),
                  ),
                ],
                onSelected: (index) {
                  // TO IMPLEMENT.
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
