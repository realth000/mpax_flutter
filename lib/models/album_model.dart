import 'package:realm/realm.dart';

part '../generated/models/album_model.g.dart';

/// Album model.
///
/// [title] together with Artist can specify a certain [Album].
@RealmModel()
class _Album {
  /// Primary key of [Album] model.
  /// Format: "Album Name" + "Artist Id".
  @PrimaryKey()
  late final String _AlbumId;

  /// Album artist hash.
  late List<int> artistList;

  /// Album title
  late String title;

  /// Artwork cover id.
  late int? artwork;

  /// Album year.
  late int? year;

  /// Total track count.
  late int? trackCount;

  /// Contained music.
  List<int> albumMusicList = <int>[];
}
