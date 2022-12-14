import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../models/play_content.model.dart';
import '../../../models/playlist.model.dart';
import '../../../services/locale_service.dart';
import '../../../services/media_library_service.dart';
import '../../../themes/media_table_themes.dart';
import 'media_table_controller.dart';
import 'media_table_toolbar.dart';

/// Audio content table widget used on desktop platforms.
class MediaTable extends StatelessWidget {
  /// Constructor.
  MediaTable(PlaylistModel playlist, {super.key}) {
    _controller.playlist.value = playlist;
  }

  /// Convert [PlutoColumnSort] to sqlite order by sort [String].
  static const _sortMap = <PlutoColumnSort, String>{
    PlutoColumnSort.none: '',
    PlutoColumnSort.ascending: 'ASC',
    PlutoColumnSort.descending: 'DESC',
  };

  final _controller = Get.put(MediaTableController(PlaylistModel()));

  late final PlutoGridStateManager? _stateManager;

  final columns = <PlutoColumn>[
    // State row, accept: String.fromCharCode(Icons.play_arrow.codePoint)
    PlutoColumn(
      title: 'State'.tr,
      field: 'state',
      type: PlutoColumnType.text(),
      renderer: (rendererContext) => Text(
        rendererContext.cell.value.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontFamily: 'MaterialIcons',
        ),
      ),
      width: 80,
      enableEditingMode: false,
      enableSorting: false,
      enableRowChecked: true,
      enableContextMenu: true,
      enableRowDrag: true,
    ),
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
      hide: true,
    ),
  ];

  List<PlutoRow> _buildRows(List<PlayContent> list) => List.generate(
        list.length,
        (index) => PlutoRow(
          cells: {
            'state': PlutoCell(
              value: list[index].contentPath ==
                      _controller.currentPlayingContent.value
                  ? playingIcon
                  : '',
            ),
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
        rows: _buildRows(_controller.playlist.value.contentList),
        onLoaded: (event) {
          // _stateManager = event.stateManager;
          _controller.tableStateManager = event.stateManager;
          // Set select row mode.
          event.stateManager.setSelectingMode(PlutoGridSelectingMode.cell);
          // _controller.playlistTableName.value =
          //     _controller.playlist.value.tableName;
          // if (_controller.playlist.value.tableName ==
          //     MediaLibraryService.allMediaTableName) {
          //   _controller.playlistName.value = 'Library'.tr;
          //   return;
          // }
          // _controller.playlistName.value = _controller.playlist.value.name;
        },
        onRowDoubleTap: (tappedRow) async {
          final row = tappedRow.row;
          if (row == null) {
            return;
          }
          await _controller.playAudio(
            _controller.playlist.value.find(row.cells['path']!.value),
            _controller.playlist.value,
          );
        },
        onSorted: (sortEvent) async {
          _controller.playlist.value.contentList = (await _controller.sort(
            _controller.playlist.value,
            sortEvent.column.field,
            _sortMap[sortEvent.column.sort]!,
          ))
              .contentList;
        },
        onRowsMoved: (movedEvent) async {
          final r = _controller.playlist.value.contentList.firstWhere(
              (element) =>
                  element.contentPath ==
                  movedEvent.rows?[0]!.cells['path']!.value);
          if (r.contentPath.isEmpty) {
            return;
          }
          _controller.playlist.value.contentList
              .removeWhere((element) => element.contentPath == r.contentPath);
          _controller.playlist.value.contentList.insert(movedEvent.idx!, r);
          await Get.find<MediaLibraryService>()
              .savePlaylist(_controller.playlist.value);
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
          if (_controller.searchEnabled.value) {
            stateManager.setShowColumnFilter(true);
          }
          return w;
        },
        // Pagination will cause _stateManager.rows only get current page rows,
        // make state signing not work, so disable it.
        // createFooter: (stateManager) {
        // if (playlist.contentList.isNotEmpty) {
        //   stateManager.setPageSize(100, notify: false);
        // }
        // return PlutoPagination(stateManager);
        // },
        // Use unique key to tell flutter to refresh!
        key: UniqueKey(),
        onRowChecked: (event) {
          if (event.isRow) {
            if (event.isChecked == null) {
              return;
            }
            if (event.isChecked!) {
              _controller.checkedRowPathList.value
                  .add(event.row!.cells['path']!.value);
            } else {
              _controller.checkedRowPathList.value
                  .remove(event.row!.cells['path']!.value);
            }
          } else {
            if (_controller.tableStateManager == null) {
              return;
            }
            _controller.checkedRowPathList.value.clear();
            for (final row in _controller.tableStateManager!.checkedRows) {
              _controller.checkedRowPathList.value
                  .add(row.cells['path']!.value);
            }
          }
        },
      );
}
