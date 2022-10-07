import 'package:flutter/material.dart';

import '../models/playlist.model.dart';
import '../widgets/media_list_item.dart';

/// Media list widget, contains a list of audio content.
class MediaList extends StatelessWidget {
  /// Constructor.
  const MediaList(this.playlist, {super.key});

  /// [PlaylistModel] to show.
  final PlaylistModel playlist;

  List<Widget> _buildMediaList() {
    final list = <Widget>[];
    for (final playContent in playlist.contentList) {
      list.add(MediaItemTile(playContent, playlist));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) => ListView(
        children: _buildMediaList(),
      );
}
