import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/playlist_model.dart';
import 'media_table_controller.dart';

/// Table to show music.
class MediaTable extends StatelessWidget {
  /// Constructor.
  MediaTable(Playlist playlist, {super.key}) {
    _controller.playlist.value = playlist;
    print(
        'AAAA desktop MediaTable playlist length: = ${playlist.musicList.length}');
  }

  final _controller = Get.put(MediaTableController(Playlist()));

  @override
  Widget build(BuildContext context) {
    final a;
    return DataTable(
      columns: [
        DataColumn(
          label: Text('name'),
        ),
        DataColumn(
          label: Text('size'),
          numeric: true,
          onSort: (index, ascending) {},
        ),
      ],
      rows: List.generate(_controller.playlist.value.musicList.length, (index) {
        final data = _controller.playlist.value.musicList[index];
        var selected = false;
        return DataRow.byIndex(
          index: index,
          cells: [
            DataCell(Text(data.fileName)),
            DataCell(Text('${data.fileSize}'))
          ],
          selected: selected,
          onSelectChanged: (value) {
            selected = value ?? false;
            print('AAAA update selected=$selected');
          },
        );
      }),
    );
  }
}
