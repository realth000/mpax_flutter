import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:path/path.dart' as path;

import '../widgets/app_player_widget.dart';

class MediaLibraryPage extends GetView<MediaLibraryService> {
  const MediaLibraryPage({super.key});

  Widget _buildMediaItem(PlayContent playContent) {
    return ListTile(
      leading: const Icon(Icons.music_note),
      title: Text(playContent.title == ""
          ? path.split(playContent.contentPath).last
          : playContent.title),
      subtitle: Text(playContent.contentPath),
    );
  }

  List<Widget> _buildMediaList() {
    List<Widget> list = <Widget>[];
    for (PlayContent playContent in controller.content) {
      list.add(_buildMediaItem(playContent));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: 'Media Library'.tr,
      ),
      bottomNavigationBar: MPaxPlayerWidget(),
      drawer: const MPaxDrawer(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Expanded(
            child: Column(
              children: _buildMediaList(),
            ),
          ),
        ),
      ),
    );
  }
}
