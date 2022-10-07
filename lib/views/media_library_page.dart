import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/media_library_service.dart';
import '../widgets/app_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_player_widget.dart';
import '../widgets/media_list.dart';

/// Media library page.
///
/// The same as PlaylistPage, but showing the library.
class MediaLibraryPage extends GetView<MediaLibraryService> {
  /// Constructor.
  const MediaLibraryPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: 'Media Library'.tr,
        ),
        bottomNavigationBar: const MPaxPlayerWidget(),
        drawer: const MPaxDrawer(),
        body: MediaList(controller.allContentModel),
      );
}
