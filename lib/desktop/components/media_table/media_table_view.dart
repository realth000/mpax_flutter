import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/play_content.model.dart';
import '../../../models/playlist.model.dart';
import '../../../services/locale_service.dart';
import '../../../services/media_library_service.dart';
import '../../../themes/media_table_themes.dart';
import 'media_table_controller.dart';
import 'toolbar/media_table_toolbar.dart';
import 'toolbar/media_table_toolbar_controller.dart';

/// Audio content table widget used on desktop platforms.
class MediaTable extends StatelessWidget {
  /// Constructor.
  MediaTable(this.playlist, {super.key});

  /// Playlist in this table.
  final PlaylistModel playlist;

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

  List<PlutoRow> _buildRows(List<PlayContent> list) => List.generate(
        list.length,
        (index) => PlutoRow(
          cells: {
            'album_title': PlutoCell(value: list[index].albumTitle),
            'title': PlutoCell(
              value: list[index].title.isEmpty
                  ? list[index].contentName
                  : list[index].title,
            ),
            'artist': PlutoCell(value: list[index].artist),
            'album_artist': PlutoCell(value: list[index].albumArtist),
            'track_number': PlutoCell(value: list[index].trackNumber),
            'length': PlutoCell(value: list[index].length),
            'path': PlutoCell(value: list[index].contentPath),
          },
        ),
      );

  PlutoGridConfiguration _themeConfig(BuildContext context) =>
      Theme.of(context).colorScheme.brightness == Brightness.dark
          ? MediaTableTheme.darkTheme
          : MediaTableTheme.lightTheme;

  @override
  Widget build(BuildContext context) => PlutoGrid(
        columns: columns,
        rows: _buildRows(playlist.contentList),
        onLoaded: (_) {
          if (playlist.tableName == MediaLibraryService.allMediaTableName) {
            Get.find<MediaTableToolbarController>().playlistName.value =
                'Library'.tr;
            return;
          }
          Get.find<MediaTableToolbarController>().playlistName.value =
              playlist.name;
        },
        onRowDoubleTap: (tappedRow) async {
          final row = tappedRow.row;
          if (row == null) {
            return;
          }
          await _controller.playAudio(
            playlist.find(row.cells['path']!.value),
            playlist,
          );
        },
        onSorted: (sortEvent) async {
          playlist.contentList = (await _controller.sort(
            playlist,
            sortEvent.column.field,
            _sortMap[sortEvent.column.sort]!,
          ))
              .contentList;
        },
        configuration: _themeConfig(context).copyWith(
          localeText: Get.find<LocaleService>().locale.value == 'zh_CN'
              ? const PlutoGridLocaleText.china()
              : const PlutoGridLocaleText(),
          columnFilter: PlutoGridColumnFilterConfig(
            filters: const [
              ...FilterHelper.defaultFilters,
            ],
            resolveDefaultColumnFilter: (column, resolver) =>
                resolver<PlutoFilterTypeContains>(),
          ),
        ),
        createHeader: (stateManager) {
          // First construct [MediaTableToolbar],
          // then find [MediaTableToolbarController].
          final w = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MediaTableToolbar(
              stateManater: stateManager,
            ),
          );
          if (Get.find<MediaTableToolbarController>().searchEnabled.value) {
            stateManager.setShowColumnFilter(true);
          }
          return w;
        },
        createFooter: (stateManager) {
          if (playlist.contentList.isNotEmpty) {
            stateManager.setPageSize(100, notify: false);
          }
          return PlutoPagination(stateManager);
        },
        key: UniqueKey(), // Use unique key to tell flutter to refresh!
      );
}
