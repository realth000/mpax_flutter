import 'package:get/get.dart';

import '../mobile/services/media_query_service.dart';
import '../models/artwork_with_type_model.dart';
import '../models/music_model.dart';
import '../services/database_service.dart';
import '../services/metadata_service.dart';

final _metadataService = Get.find<MetadataService>();

final _mediaQueryService = Get.find<MediaQueryService>();

/// Reload audio info;
Future<Music> reloadContent(Music music) async {
  print('AAAA reloadContent');
// Load album cover from file.
  final metadata = await _metadataService.readMetadata(
    music.filePath,
    loadImage: true,
  );
  if (metadata == null) {
    return music;
  }
  final storage = Get.find<DatabaseService>().storage;

  /// Reload and save the reloaded [Artwork] data to [music].
  if (metadata.artworkMap != null && metadata.artworkMap!.isNotEmpty) {
    final metadataService = Get.find<MetadataService>();
    metadata.artworkMap!.forEach((type, artwork) async {
      // Check whether [type] already exists.
      for (var i = 0; i < music.artworkList.length; i++) {
        if (music.artworkList.elementAt(i).type == type) {
          final tmpArtwork = await metadataService.fetchArtwork(
            artwork.format,
            artwork.data,
          );
          music.artworkList.elementAt(i).artwork.value = tmpArtwork;
          return;
        }
      }
      // Now [type] not exists in [artworkList], add a new one.
      final tmpArtwork = ArtworkWithType(type)
        ..artwork.value =
            await metadataService.fetchArtwork(artwork.format, artwork.data);
      await storage.writeTxn(() async {
        await tmpArtwork.save();
        await storage.musics.put(music);
      });
      music.artworkList.add(tmpArtwork);
    });
    await storage.writeTxn(() async => music.artworkList.save());
  }
// Load album cover from Android media store.
  final am = _mediaQueryService.audioList.firstWhereOrNull(
    (audio) => audio.data == music.filePath,
  );
  if (am != null) {
    final albumCover = await _mediaQueryService.loadAlbumCover(am);
    if (albumCover.isNotEmpty) {
      // playContent.albumCover = albumCover;
    }
  }
  return music;
}
