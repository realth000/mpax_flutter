import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import '../models/play_content.model.dart';
import '../models/playlist.model.dart';
import '../services/metadata_service.dart';
import '../services/player_service.dart';
import '../widgets/media_menu.dart';
import '../widgets/util_widgets.dart';

/// Controller widget.
class MediaItemController extends GetxController {
  /// Constructor.
  MediaItemController(PlayContent playContent, this.model) {
    this.playContent.value = playContent;
  }

  /// Global player service.
  PlayerService playerService = Get.find<PlayerService>();

  /// Current audio content.
  final playContent = PlayContent().obs;

  /// Current audio content album cover image (base64 encoded).
  ///
  /// Album cover in mobile media playlist [ListView] is lazy loaded, means
  /// there is a delay between "get [playContent] from database file" and "load
  /// album cover image from file", this can help reduce database file size and
  /// make generating database file costs less time.
  /// But this also means we should have an extra variable to store the picture
  /// data to "change" and tell GetX to refresh UI, because [playContent] not
  /// "changes" if only [playContent.albumCover] changes.
  /// In future, if need to refresh other info in UI (such as title, artist and
  /// album), we may need to do the same (use extra variables).
  final playContentAlbumCover = ''.obs;

  /// Current controlling model.
  PlaylistModel model;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadAlbumCover();
  }

  Future<void> _loadAlbumCover() async {
    playContentAlbumCover.value =
        (await Get.find<MetadataService>().readMetadata(
      playContent.value.contentPath,
      loadImage: true,
    ))
            .albumCover;
  }

  /// Tell the player service to play current audio content.
  Future<void> play() async {
    if (playContent.value.contentPath.isEmpty) {
      // Not play empty path.
      return;
    }
    await playerService.setCurrentContent(playContent.value, model);
    await playerService.play();
  }
}

/// Widget for audio content to show in list.
class MediaItemTile extends StatelessWidget {
  /// Constructor.
  MediaItemTile(PlayContent playContent, this.model, {super.key}) {
    _controller = Get.put(
      MediaItemController(playContent, model),
      tag: playContent.contentPath,
    );
  }

  /// Controller of current content.
  late final MediaItemController _controller;

  /// Playlist of current content.
  final PlaylistModel model;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Obx(
          () => _controller.playContentAlbumCover.value.isEmpty
              ? const SizedBox(
                  width: 56,
                  height: 56,
                  child: Icon(Icons.music_note),
                )
              : Image.memory(
                  base64Decode(_controller.playContentAlbumCover.value),
                  width: 56,
                  height: 56,
                  isAntiAlias: true,
                ),
        ),
        title: Text(
          _controller.playContent.value.title.isEmpty
              ? path.basename(_controller.playContent.value.contentPath)
              : _controller.playContent.value.title,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _controller.playContent.value.artist,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              _controller.playContent.value.albumTitle.isEmpty
                  ? _controller.playContent.value.contentPath
                      .replaceFirst('/storage/emulated/0/', '')
                  : _controller.playContent.value.albumTitle,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () async {
            final result = await Get.dialog(
              MediaItemMenu(_controller.playContent.value, _controller.model),
            );
            switch (result) {
              case MediaItemMenuActions.play:
                await _controller.play();
                break;
              case MediaItemMenuActions.viewMetadata:
                await Get.dialog(
                  MediaMetadataDialog(_controller.playContent.value),
                );
            }
          },
          icon: const Icon(Icons.more_horiz),
        ),
        onTap: () async {
          await _controller.play();
        },
        // This important.
        isThreeLine: true,
      );
}

/// Menu to show the metadata in current content.
class MediaMetadataDialog extends StatelessWidget {
  /// Constructor.
  MediaMetadataDialog(this.playContent, {super.key});

  /// audio content to show.
  final PlayContent playContent;
  final _formKey = GlobalKey<FormState>();

  /// Widget list.
  final widgetList = <Widget>[];

  /// Space height between metadata.
  static const spaceHeight = 10.0;

  void _addReadonlyProperty(String property, String propertyName) {
    widgetList.add(
      TextFormField(
        controller: TextEditingController(
          text: property,
          // playContent.contentPath.replaceFirst('/storage/emulated/0/', ''),
        ),
        readOnly: true,
        decoration: InputDecoration(
          labelText: propertyName,
          // labelText: 'File path'.tr,
        ),
      ),
    );
  }

  void _addSpace() {
    widgetList.add(
      const SizedBox(
        width: spaceHeight,
        height: spaceHeight,
      ),
    );
  }

  String _toReadableSize(int size) {
    var d = 0;
    var s = size;
    while (s >= 1024 && d < 3) {
      s ~/= 1024;
      d++;
    }

    switch (d) {
      case 0:
        return '$s B';
      case 1:
        return '$s KB';
      case 2:
        return '$s MB';
      case 3:
        return '$s GB';
      case 4:
        return '$s TB';
      default:
        return '$s ??';
    }
  }

  List<Widget> _buildMetadataList() {
    _addReadonlyProperty(
      playContent.contentPath.replaceFirst('/storage/emulated/0/', ''),
      'File path'.tr,
    );
    if (playContent.contentName.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(
        playContent.contentName,
        'File name'.tr,
      );
    }
    if (playContent.contentSize > 0) {
      _addSpace();
      _addReadonlyProperty(
        '${_toReadableSize(playContent.contentSize)}'
        '(${playContent.contentSize} Bytes)',
        'File size'.tr,
      );
    }
    if (playContent.title.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(
        playContent.title,
        'Title'.tr,
      );
    }
    if (playContent.artist.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(
        playContent.artist,
        'Artist'.tr,
      );
    }
    if (playContent.trackNumber >= 0) {
      _addSpace();
      _addReadonlyProperty(
        '${playContent.trackNumber}',
        'Track number'.tr,
      );
    }
    if (playContent.albumTitle.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(
        playContent.albumTitle,
        'Album name'.tr,
      );
    }
    if (playContent.albumArtist.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(
        playContent.albumArtist,
        'Album artist'.tr,
      );
    }
    if (playContent.albumYear >= 0) {
      _addSpace();
      _addReadonlyProperty(
        '${playContent.albumYear}',
        'Album year'.tr,
      );
    }
    if (playContent.albumTrackCount >= 0) {
      _addSpace();
      _addReadonlyProperty(
        '${playContent.albumTrackCount}',
        'Album track count'.tr,
      );
    }
    if (playContent.genre.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.genre, 'Genre'.tr);
    }
    if (playContent.length > 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.length} s', 'Length'.tr);
    }
    if (playContent.sampleRate > 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.sampleRate} Hz', 'Sample Rate'.tr);
    }
    if (playContent.bitRate > 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.bitRate} kbps', 'Bitrate'.tr);
    }
    if (playContent.channels > 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.channels}', 'Channels'.tr);
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) => ModalDialog(
        showScrollbar: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: _buildMetadataList(),
                ),
              )
            ],
          ),
        ),
      );
}
