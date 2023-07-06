import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/music_model.dart';

part 'album_model.g.dart';

/// Album model.
///
/// [title] together with Artist can specify a certain [Album].
@Collection()
class Album {
  /// Constructor
  Album({
    required this.title,
    this.year,
    this.trackCount,
    List<Id>? artistIds,
  }) {
    if (artistIds != null) {
      /// [addAll] will automatically filter duplicate [Id].
      artistList.addAll(artistIds);
    }
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Album artist hash.
  @Index(
    unique: true,
    composite: [CompositeIndex('title')],
  )
  late List<Id> artistList;

  /// Album title
  @Index()
  String title;

  /// All related artwork.
  ///
  /// Use a [Set] of [Artwork] [Id].
  /// Not have a artwork type because all artwork with type are only
  /// related to [Music].
  late List<Id> artworkList;

  /// Album year.
  int? year;

  /// Total track count.
  int? trackCount;

  /// Contained music.
  late List<Id> albumMusicList;

  Album makeGrowable() {
    return this
      ..artistList = artistList.toList()
      ..artworkList = artworkList.toList()
      ..albumMusicList = albumMusicList.toList();
  }
}
