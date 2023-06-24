import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mpax_flutter/mobile/components/mobile_underfoot.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/media_list.dart';

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
          actions: <Widget>[
            IconButton(
              onPressed: () async => throw UnimplementedError(
                'Search page route need add playlist id',
              ),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        drawer: const MPaxDrawer(),
        body: Obx(() => MediaList(controller.allMusic.value)),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
      );
}
