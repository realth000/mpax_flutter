import 'package:isar/isar.dart';

import 'album_model.dart';
import 'music_model.dart';

/// Artist model.
@Collection()
class Artist {
  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Artist name, should be unique.
  @Index(unique: true, caseSensitive: true)
  String name = '';

  /// All music performed by this artist.
  final musicList = IsarLinks<Music>();

  /// All albums related.
  final albumList = IsarLinks<Album>();
}
