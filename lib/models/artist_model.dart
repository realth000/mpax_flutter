import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/album_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/services/database_service.dart';

part 'artist_model.g.dart';

/// Artist model.
@Collection()
class Artist {
  /// Constructor.
  Artist({required this.name});

  /// Add music.
  Future<void> addMusic(Music music) async {
    for (final m in musicList) {
      if (m.filePath == music.filePath) {
        return;
      }
    }
    musicList.add(music);
    await Get.find<DatabaseService>().writeTxn(() async => musicList.save());
    if (music.album.value != null) {
      var contains = false;
      final tmpAlbum = music.album.value!;
      for (final m in albumList) {
        if (m.title == tmpAlbum.title &&
            m.artistNamesHash == tmpAlbum.artistNamesHash) {
          contains = true;
          break;
        }
      }
      if (!contains) {
        albumList.add(music.album.value!);
        await Get.find<DatabaseService>()
            .writeTxn(() async => albumList.save());
      }
    }
    await Get.find<DatabaseService>().saveArtist(this);
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Artist name, should be unique.
  @Index(unique: true)
  String name;

  /// All music performed by this artist.
  @Backlink(to: 'artists')
  final musicList = IsarLinks<Music>();

  /// All albums related.
  @Backlink(to: 'artists')
  final albumList = IsarLinks<Album>();
}
