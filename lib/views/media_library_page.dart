import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';

import '../widgets/app_player_widget.dart';
import '../widgets/media_list_item.dart';

class MediaLibraryPage extends GetView<MediaLibraryService> {
  const MediaLibraryPage({super.key});

  List<Widget> _buildMediaList() {
    List<Widget> list = <Widget>[];
    for (PlayContent playContent in controller.content) {
      list.add(MediaItemTile(playContent, controller.allContentModel));
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
          child: Column(
            children: _buildMediaList(),
          ),
        ),
      ),
    );
  }
}
