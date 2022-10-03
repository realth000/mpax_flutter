import 'package:flutter/material.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/widgets/media_list_item.dart';

class MediaList extends StatelessWidget {
  const MediaList(this.playlist, {super.key});

  final PlaylistModel playlist;

  List<Widget> _buildMediaList() {
    var list = <Widget>[];
    for (final playContent in playlist.contentList) {
      list.add(MediaItemTile(playContent, playlist));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _buildMediaList(),
    );
  }
}
