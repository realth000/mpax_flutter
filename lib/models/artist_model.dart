import 'package:isar/isar.dart';

import 'album_model.dart';
import 'music_model.dart';

part 'artist_model.g.dart';

/// Artist model.
@Collection()
class Artist {
  /// Constructor.
  Artist({required this.name});

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
