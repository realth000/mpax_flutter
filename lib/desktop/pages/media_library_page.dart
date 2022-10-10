import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/media_library_service.dart';
import '../../widgets/media_list.dart';

class DesktopMediaLibraryPage extends GetView<MediaLibraryService> {
  @override
  Widget build(BuildContext context) {
    return MediaList(controller.allContentModel);
  }
}
