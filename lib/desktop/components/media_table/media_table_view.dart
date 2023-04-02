import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/playlist_model.dart';
import '../../../services/player_service.dart';
import 'media_table_controller.dart';

/// Table to show music.
class MediaTable extends StatelessWidget {
  /// Constructor.
  MediaTable(Playlist playlist, {super.key}) {
    _controller.playlist.value = playlist;
    print(
        'AAAA desktop MediaTable playlist length: = ${playlist.musicList.length}');
  }
  final _playerService = Get.find<PlayerService>();

  /// Scroll controller for playlist table.
  final _scrollController = ScrollController();

  /// Playlist controller.
  final _controller = Get.put(MediaTableController(Playlist()));

  /// If true, show select [Checkbox] in the first column.
  final _showSelect = false.obs;

  List<DataRow> _buildDataRows(bool showSelect) =>
      List.generate(_controller.playlist.value.musicList.length, (index) {
        final data = _controller.playlist.value.musicList.elementAt(index);
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(
              Text(data.fileName),
              onDoubleTap: () async {
                await _playerService.setCurrentContent(
                  data,
                  _controller.playlist.value,
                );
                await _playerService.play();
              },
            ),
            DataCell(
              Text('${data.fileSize}'),
              onTap: () {},
            ),
          ],
          selected: _controller.selectStateList[index],
          onSelectChanged: _showSelect.value
              ? (value) {
                  if (value == null) {
                    return;
                  }
                  _controller.selectStateList[index] = value;
                  _controller.selectStateList.refresh();
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
