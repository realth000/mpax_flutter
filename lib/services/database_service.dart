import 'package:get/get.dart';
import 'package:isar/isar.dart';

import '../models/album_model.dart';
import '../models/artist_model.dart';
import '../models/artwork_model.dart';
import '../models/music_model.dart';
import '../models/playlist_model.dart';

/// Database storage service.
///
/// Provide methods related to database tables.
class DatabaseService extends GetxService {
  /// Music storage.
  late final Isar storage;

  /// Init function, run before app start.
  Future<DatabaseService> init() async {
    storage = await Isar.open([
      AlbumSchema,
      ArtistSchema,
      ArtworkSchema,
      ArtworkWithTypeSchema,
      MusicSchema,
      PlaylistModelSchema,
    ]);
    return this;
  }
}
