import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/playlist.model.dart';
import '../../../themes/media_table_themes.dart';
import 'media_table_controller.dart';

/// Audio content table widget used on desktop platforms.
class MediaTable extends StatelessWidget {
  /// Constructor.
  MediaTable(this.playlistModel, {super.key});

  /// Playlist in this table.
  PlaylistModel playlistModel;

  /// State manager reserved to change table state.
  ///
  /// We use this because we do not have method to access
  /// [PlutoGridStateManager] without any event callback.
  late final PlutoGridStateManager _stateManager;

  /// Convert [PlutoColumnSort] to sqlite order by sort [String].
  static const _sortMap = <PlutoColumnSort, String>{
    PlutoColumnSort.none: '',
    PlutoColumnSort.ascending: 'ASC',
    PlutoColumnSort.descending: 'DESC',
  };

  final _controller = Get.put(MediaTableController());

  final columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Album name'.tr,
      field: 'album_title',
      type: PlutoColumnType.text(),
      readOnly: true,
    ),
    PlutoColumn(
      title: 'Title'.tr,
      field: 'title',
      type: PlutoColumnType.text(),
      readOnly: true,
    ),
    PlutoColumn(
      title: 'Artist'.tr,
      field: 'artist',
      type: PlutoColumnType.text(),
      readOnly: true,
    ),
    PlutoColumn(
      title: 'Album artist'.tr,
      field: 'album_artist',
      type: PlutoColumnType.text(),
      readOnly: true,
      hide: true,
    ),
    PlutoColumn(
      title: 'Track number'.tr,
      field: 'track_number',
      type: PlutoColumnType.text(),
      readOnly: true,
      hide: true,
    ),
    PlutoColumn(
      title: 'Duration'.tr,
      field: 'length'.tr,
      type: PlutoColumnType.text(),
      readOnly: true,
      hide: true,
    ),
    PlutoColumn(
      title: 'File path'.tr,
      field: 'path',
      type: PlutoColumnType.text(),
      readOnly: true,
    ),
  ];

  late final List<PlutoRow> rows = _buildTableRows();

  List<PlutoRow> _buildTableRows() {
    final r = <PlutoRow>[];
    for (final content in playlistModel.contentList) {
      r.add(
        PlutoRow(
          cells: {
            'album_title': PlutoCell(value: content.albumTitle),
            'title': PlutoCell(
              value:
                  content.title.isEmpty ? content.contentName : content.title,
            ),
            'artist': PlutoCell(value: content.artist),
            'album_artist': PlutoCell(value: content.albumArtist),
            'track_number': PlutoCell(value: content.trackNumber),
            'length': PlutoCell(value: content.length),
            'path': PlutoCell(value: content.contentPath),
          },
        ),
      );
    }
    return r;
  }

  PlutoGridConfiguration _themeConfig(BuildContext context) =>
      Theme.of(context).colorScheme.brightness == Brightness.dark
          ? MediaTableTheme.darkTheme
          : MediaTableTheme.lightTheme;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          PlutoGrid(
            columns: columns,
            rows: rows,
            onRowDoubleTap: (tappedRow) async {
              final row = tappedRow.row;
              if (row == null) {
                return;
              }
              await _controller.playAudio(
                playlistModel.find(row.cells['path']!.value),
                playlistModel,
              );
            },
            onLoaded: (event) {
              // Reserve the state manager.
              _stateManager = event.stateManager;
            },
            onSorted: (sortEvent) async {
              playlistModel = await _controller.sort(
                playlistModel,
                sortEvent.column.field,
                _sortMap[sortEvent.column.sort]!,
              );
            },
            configuration: _themeConfig(context).copyWith(
              columnFilter: PlutoGridColumnFilterConfig(
                filters: const [
                  ...FilterHelper.defaultFilters,
                ],
                resolveDefaultColumnFilter: (column, resolver) =>
                    resolver<PlutoFilterTypeContains>(),
              ),
            ),
            createFooter: (stateManager) {
              stateManager.setPageSize(100, notify: false);
              return PlutoPagination(stateManager);
            },
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: ElevatedButton(
              onPressed: () {
                _controller.showFiltersRow.value =
                    !_controller.showFiltersRow.value;
                _stateManager
                    .setShowColumnFilter(_controller.showFiltersRow.value);
              },
              child: const Icon(Icons.search),
            ),
          ),
        ],
      );
}
