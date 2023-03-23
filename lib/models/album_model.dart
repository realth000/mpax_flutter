import 'package:isar/isar.dart';

import 'artist_model.dart';
import 'artwork_model.dart';
import 'music_model.dart';

/// Album model.
///
/// [title] together with [artist] can specify a certain [Album].
@Collection()
class Album {
  /// Constructor
  Album({
    required this.title,
    this.year,
    this.trackCount,
  });

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Album title
  @Index(
    unique: true,
    caseSensitive: true,
    composite: [CompositeIndex('artist')],
  )
  String title;

  /// Album artist.
  final artist = IsarLinks<Artist>();

  /// Album cover data, base64 encoded.
  ///
  /// May change but currently we only use one at the same time.
  /// User may choose from [Artwork]s in [albumMusic].
  final artworkList = IsarLinks<Artwork>();

  /// Album year.
  int? year;

  /// Total track count.
  int? trackCount;

  /// Contained music.
  @Backlink(to: 'album')
  final albumMusic = IsarLinks<Music>();
}
