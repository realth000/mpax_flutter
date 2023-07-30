import 'package:isar/isar.dart';

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
  List<int> artistList = <int>[];

  /// Album title
  @Index()
  String title;

  /// Artwork cover id.
  int? artwork;

  /// Album year.
  int? year;

  /// Total track count.
  int? trackCount;

  /// Contained music.
  List<int> albumMusicList = <int>[];

  Album makeGrowable() {
    return this
      ..artistList = artistList.toList()
      ..albumMusicList = albumMusicList.toList();
  }
}
