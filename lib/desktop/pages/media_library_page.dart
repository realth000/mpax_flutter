import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/desktop/components/media_table/media_table_view.dart';
import 'package:mpax_flutter/services/media_library_service.dart';

class DesktopMediaLibraryPage extends GetView<MediaLibraryService> {
  const DesktopMediaLibraryPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          return MediaTable(controller.allMusic.value);
        }),
      );
}
