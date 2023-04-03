import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../../../models/playlist_model.dart';
import '../../../services/database_service.dart';
import '../../../services/player_service.dart';
import 'media_table_controller.dart';

/// Table to show music.
class MediaTable extends StatelessWidget {
  /// Constructor.
  MediaTable(Playlist playlist, {super.key}) {
    _controller.updatePlaylist(playlist);
  }
  final _playerService = Get.find<PlayerService>();

  /// Scroll controller for playlist table.
  final _scrollController = ScrollController();

  /// Playlist controller.
  final _controller = Get.put(MediaTableController());

  /// If true, show select [Checkbox] in the first column.
  final _showSelect = false.obs;

  List<DataRow> _buildDataRows(bool showSelect) =>
      List.generate(_controller.rows.length, (index) {
        final data = _controller.rows.elementAt(index);
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(
              Text(data.music.fileName),
              onDoubleTap: () async {
                final p = await Get.find<DatabaseService>()
                    .storage
                    .playlists
                    .where()
                    .idEqualTo(_controller.playlistId.value)
                    .findFirst();
                await _playerService.setCurrentContent(
                  data.music,
                  p!,
                );
                await _playerService.play();
              },
            ),
            DataCell(
              Text('${data.music.fileSize}'),
              onTap: () {},
            ),
          ],
          selected: data.selected.value,
          onSelectChanged: _showSelect.value
              ? (value) {
                  if (value == null) {
                    return;
                  }
                  data.selected.value = value;
                }
              : null,
        );
      });

  @override
  Widget build(BuildContext context) {
    final a;
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                _showSelect.value = !_showSelect.value;
              },
              child: Text('Show Select'), // This should in toolbar.
            ),
          ],
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Obx(
                () => DataTable(
                  columns: [
                    DataColumn(
                      label: Text('Title'.tr),
                    ),
                    DataColumn(
                      label: Text('File size'.tr),
                      numeric: true,
                    ),
                  ],
                  rows: _buildDataRows(_showSelect.value),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
