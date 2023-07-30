import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/music_model.dart';

part 'artist_model.g.dart';

/// Artist model.
@Collection()
class Artist {
  /// Constructor.
  Artist({required this.name});

  /// Add music.
  Future<void> addMusic(Music music) async {
    if (musicList.contains(music.id)) {
      return;
    }
    musicList.add(music.id);
    if (music.album != null && albumList.contains(music.album!)) {
      albumList.add(music.album!);
    }
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Artist name, should be unique.
  @Index(unique: true)
  String name;

  /// All music performed by this artist.
  List<Id> musicList = <Id>[];

  /// All albums related.
  List<Id> albumList = <Id>[];

  Artist makeGrowable() {
    return this
      ..musicList = musicList.toList()
      ..albumList = albumList.toList();
  }
}
