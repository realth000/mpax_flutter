import 'package:get/get.dart';

import '../mobile/services/media_query_service.dart';
import '../models/play_content.model.dart';
import '../services/metadata_service.dart';

final _metadataService = Get.find<MetadataService>();

final _mediaQueryService = Get.find<MediaQueryService>();

/// Reload audio info;
Future<PlayContent> reloadContent(PlayContent playContent) async {
// Load album cover from file.
  final p = await _metadataService.readMetadata(
    playContent.contentPath,
    loadImage: true,
  );
  if (p.albumCover.isNotEmpty) {
    playContent.albumCover = p.albumCover;
    return playContent;
  }
// Load album cover from Android media store.
  final am = _mediaQueryService.audioList.firstWhereOrNull(
    (audio) => audio.data == playContent.contentPath,
  );
  if (am != null) {
    final albumCover = await _mediaQueryService.loadAlbumCover(am);
    if (albumCover.isNotEmpty) {
      playContent.albumCover = albumCover;
    }
  }
  return playContent;
}