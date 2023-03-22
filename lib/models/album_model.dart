import 'package:isar/isar.dart';

import 'artwork_model.dart';
import 'music_model.dart';

/// Album model.
@Collection()
class Album {
  /// Constructor
  Album({
    required this.title,
    this.artist,
    this.year,
    this.trackCount,
  });

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Album title
  @Index(
    unique: true,
    caseSensitive: false,
    composite: [CompositeIndex('artist')],
  )
  String title;

  /// Album artist.
  String? artist;

  /// Album cover data, base64 encoded.
  ///
  /// May change but currently we only use one at the same time.
  /// User may choose from [Artwork]s in [albumMusic].
  final artworkList = IsarLink<Artwork>();

  /// Album year.
  int? year;

  /// Total track count.
  int? trackCount;

  /// Contained music.
  @Backlink(to: 'Music')
  final albumMusic = IsarLink<Music>();
}
