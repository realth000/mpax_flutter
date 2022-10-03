import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/player_service.dart';
import 'package:mpax_flutter/widgets/media_menu.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';
import 'package:path/path.dart' as path;

class MediaItemController extends GetxController {
  MediaItemController(this.playContent, this.model);

  PlayerService playerService = Get.find<PlayerService>();
  PlayContent playContent;
  PlaylistModel model;

  Future<void> play() async {
    if (playContent.contentPath.isEmpty) {
      // Not play empty path.
      return;
    }
    await playerService.setCurrentContent(playContent, model);
    await playerService.play();
  }
}

class MediaItemTile extends StatelessWidget {
  MediaItemTile(this.playContent, this.model, {super.key}) {
    _controller = MediaItemController(playContent, model);
  }

  final PlayContent playContent;
  late final MediaItemController _controller;
  final PlaylistModel model;

  Widget _leadingIcon() {
    if (playContent.albumCover.isEmpty) {
      return const SizedBox(
        height: 56,
        width: 56,
        child: Icon(Icons.music_note),
      );
    }
    return SizedBox(
      height: 56,
      width: 56,
      child: Image.memory(
        base64Decode(playContent.albumCover),
        width: 60.0,
        height: 60.0,
        isAntiAlias: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ListTileLeading(child: _leadingIcon()),
      title: Text(
        playContent.title.isEmpty
            ? path.basename(playContent.contentPath)
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
                ? playContent.contentPath
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
              MediaItemMenu(_controller.playContent, _controller.model));
          switch (result) {
            case MediaItemMenuActions.play:
              _controller.play();
              break;
            case MediaItemMenuActions.viewMetadata:
              Get.dialog(MediaMetadataDialog(playContent));
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
}

class MediaMetadataDialog extends StatelessWidget {
  MediaMetadataDialog(this.playContent, {super.key});

  final PlayContent playContent;
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();
  final List<Widget> widgetList = <Widget>[];
  static const spaceHeight = 10.0;

  void _addReadonlyProperty(String property, String propertyName) {
    widgetList.add(TextFormField(
      controller: TextEditingController(
        text: property,
        // playContent.contentPath.replaceFirst('/storage/emulated/0/', ''),
      ),
      readOnly: true,
      decoration: InputDecoration(
        labelText: propertyName,
        // labelText: 'File path'.tr,
      ),
    ));
  }

  void _addSpace() {
    widgetList.add(const SizedBox(
      width: spaceHeight,
      height: spaceHeight,
    ));
  }

  String _toReadableSize(int size) {
    int d = 0;
    while (size >= 1024 && d < 3) {
      size ~/= 1024;
      d++;
    }

    switch (d) {
      case 0:
        return '$size B';
      case 1:
        return '$size KB';
      case 2:
        return '$size MB';
      case 3:
        return '$size GB';
      case 4:
        return '$size TB';
      default:
        return '$size ??';
    }
  }

  List<Widget> _buildMetadataList() {
    _addReadonlyProperty(
        playContent.contentPath.replaceFirst('/storage/emulated/0/', ''),
        'File path'.tr);
    if (playContent.contentName.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.contentName, 'File name'.tr);
    }
    if (playContent.contentSize > 0) {
      _addSpace();
      _addReadonlyProperty(
          '${_toReadableSize(playContent.contentSize)}(${playContent.contentSize} Bytes)',
          'File size'.tr);
    }
    if (playContent.title.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.title, 'Title'.tr);
    }
    if (playContent.artist.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.artist, 'Artist'.tr);
    }
    if (playContent.trackNumber >= 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.trackNumber}', 'Track number'.tr);
    }
    if (playContent.albumTitle.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.albumTitle, 'Album name'.tr);
    }
    if (playContent.albumArtist.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.albumArtist, 'Album artist'.tr);
    }
    if (playContent.albumYear >= 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.albumYear}', 'Album year'.tr);
    }
    if (playContent.albumTrackCount >= 0) {
      _addSpace();
      _addReadonlyProperty(
          '${playContent.albumTrackCount}', 'Album track count'.tr);
    }
    if (playContent.genre.isNotEmpty) {
      _addSpace();
      _addReadonlyProperty(playContent.genre, 'Genre'.tr);
    }
    if (playContent.length > 0) {
      _addSpace();
      _addReadonlyProperty('${playContent.length}', 'Length');
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return ModalDialog(
      showScrollbar: false,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
}
