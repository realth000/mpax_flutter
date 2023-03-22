import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import '../models/music_model.dart';
import '../models/playlist_model.dart';
import '../services/player_service.dart';
import '../widgets/media_menu.dart';
import '../widgets/util_widgets.dart';

/// Controller widget.
class MediaItemController extends GetxController {
  /// Constructor.
  MediaItemController(this.playContent, this.model);

  /// Global player service.
  PlayerService playerService = Get.find<PlayerService>();

  /// Current audio content.
  Music playContent;

  /// Current controlling model.
  PlaylistModel model;

  /// Tell the player service to play current audio content.
  Future<void> play() async {
    if (playContent.filePath.isEmpty) {
      // Not play empty path.
      return;
    }
    await playerService.setCurrentContent(playContent, model);
    await playerService.play();
  }
}

/// Widget for audio content to show in list.
class MediaItemTile extends StatelessWidget {
  /// Constructor.
  MediaItemTile(this.playContent, this.model, {super.key}) {
    _controller = MediaItemController(playContent, model);
  }

  /// Current content.
  final Music playContent;

  /// Controller of current content.
  late final MediaItemController _controller;

  /// Playlist of current content.
  final PlaylistModel model;

  Widget _leadingIcon() {
    if (playContent.albumCover.isEmpty) {
      return const SizedBox(
        width: 56,
        height: 56,
        child: Icon(Icons.music_note),
      );
    }
    return Image.memory(
      base64Decode(playContent.albumCover),
      width: 56,
      height: 56,
      isAntiAlias: true,
    );
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: ListTileLeading(child: _leadingIcon()),
        title: Text(
          playContent.title.isEmpty
              ? path.basename(playContent.filePath)
              : playContent.title,
          maxLines: 2,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              playContent.artist,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              playContent.albumTitle.isEmpty
                  ? playContent.filePath
                      .replaceFirst('/storage/emulated/0/', '')
                  : playContent.albumTitle,
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
              MediaItemMenu(_controller.playContent, _controller.model),
            );
            switch (result) {
              case MediaItemMenuActions.play:
                await _controller.play();
                break;
              case MediaItemMenuActions.viewMetadata:
                await Get.dialog(MediaMetadataDialog(playContent));
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
  final Music playContent;
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
      playContent.filePath.replaceFirst('/storage/emulated/0/', ''),
      'File path'.tr,
    );
    if (playContent.fileName.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(
        playContent.fileName,
        'File name'.tr,
      );
    }
    if (playContent.fileSize > 0) {
      _addSpace();
      _addReadonlyProperty(
        '${_toReadableSize(playContent.fileSize)}'
        '(${playContent.fileSize} Bytes)',
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
