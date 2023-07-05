import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/mobile/services/media_query_service.dart';
import 'package:mpax_flutter/models/artwork_with_type_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';

final _metadataService = Get.find<MetadataService>();

final _mediaQueryService = Get.find<MediaQueryService>();

/// Reload audio info;
Future<Music> reloadMusicContent(Music music) async {
// Load album cover from file.
//   final metadata = await _metadataService.readMetadata(
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
        final artworkWithType = await storage.artworkWithTypes
            .where()
            .idEqualTo(music.artistList.elementAt(i))
            .findFirst();
        if (artworkWithType == null || artworkWithType.type != type) {
          continue;
        }
        final tmpArtwork = await metadataService.fetchArtwork(
          artwork.format,
          artwork.data,
        );
        artworkWithType.id = tmpArtwork.id;
        await storage.writeTxn(
            () async => storage.artworkWithTypes.put(artworkWithType));
        return;
      }
      // Now [type] not exists in [artworkList], add a new one.
      final tmpArtwork = ArtworkWithType(
          (await metadataService.fetchArtwork(artwork.format, artwork.data)).id,
          type);
      music.artworkList.add(tmpArtwork.id);
      await storage.writeTxn(() async {
        await tmpArtwork.save();
        await storage.musics.put(music);
      });
    });
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
