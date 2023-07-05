import 'package:get/get.dart';
import 'package:isar/isar.dart';
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
    musicList.add(music.id);
    if (music.album != null) {
      albumList.add(music.album!);
    }
    await Get.find<DatabaseService>().saveArtist(this);
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Artist name, should be unique.
  @Index(unique: true)
  String name;

  /// All music performed by this artist.
  final musicList = <Id>[];

  /// All albums related.
  final albumList = <Id>[];
}
