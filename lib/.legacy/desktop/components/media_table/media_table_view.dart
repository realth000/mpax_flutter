import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/desktop/components/media_table/media_table_controller.dart';
import 'package:mpax_flutter/desktop/components/media_table/media_table_toolbar.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:mpax_flutter/services/player_service.dart';

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
          onSelectChanged: _controller.showSelect.value
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
    return Column(
      children: [
        const MediaTableToolbar(),
        // Row(
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         _controller.showSelect.value = !_controller.showSelect.value;
        //       },
        //       child: Text('Show Select'), // This should in toolbar.
        //     ),
        //   ],
        // ),
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
                  rows: _buildDataRows(_controller.showSelect.value),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
