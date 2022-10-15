import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/media_library_service.dart';
import '../components/media_table/media_table_view.dart';

class DesktopMediaLibraryPage extends GetView<MediaLibraryService> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: MediaTable(controller.allContentModel),
      );
}
