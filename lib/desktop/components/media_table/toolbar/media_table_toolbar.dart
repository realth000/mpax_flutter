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

  final _controller = Get.put(MediaTableToolbarController());

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => TitleText(title: _controller.playlistName.value, level: 0),
          ),
          Row(
            children: [
              Text('Search'.tr),
              Obx(
                () => Switch(
                  value: _controller.searchEnabled.value,
                  onChanged: (value) {
                    _controller.searchEnabled.value = value;
                    stateManater.setShowColumnFilter(value);
                  },
                ),
              ),
            ],
          ),
        ],
      );
}
