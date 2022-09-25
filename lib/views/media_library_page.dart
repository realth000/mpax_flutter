import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/media_list_item.dart';

class MediaLibraryPage extends GetView<MediaLibraryService> {
  const MediaLibraryPage({super.key});

  List<Widget> _buildMediaList() {
    var list = <Widget>[];
    for (final playContent in controller.content) {
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
      bottomNavigationBar: const MPaxPlayerWidget(),
      drawer: const MPaxDrawer(),
      body: ListView(
        shrinkWrap: true,
        children: _buildMediaList(),
      ),
    );
  }
}
