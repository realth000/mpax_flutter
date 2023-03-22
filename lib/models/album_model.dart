import 'package:isar/isar.dart';

import 'music_model.dart';

/// Album model.
@Collection()
class Album {
  /// Constructor
  Album({required this.title, required this.albumArtist});

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Album title
  @Index(
      unique: true, caseSensitive: false, composite: [CompositeIndex('artist')])
  String title;

  /// Album artist.
  String albumArtist;

  /// Contained music.
  @Backlink(to: 'Music')
  final albumMusic = IsarLink<Music>();
}
