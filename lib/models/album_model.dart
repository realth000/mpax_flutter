import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

import 'artist_model.dart';
import 'artwork_model.dart';
import 'music_model.dart';

part 'album_model.g.dart';

/// Album model.
///
/// [title] together with [artists] can specify a certain [Album].
@Collection()
class Album {
  /// Constructor
  Album({
    required this.title,
    this.year,
    this.trackCount,
    List<String>? artistNames,
  }) {
    if (artistNames == null || artistNames.isEmpty) {
      _artistNamesHash =
          md5.convert([DateTime.now().microsecondsSinceEpoch]).toString();
    } else {
      _artistNamesHash = md5
          .convert(
            artistNames
                .sorted(
                    (s1, s2) => s1.toLowerCase().compareTo(s2.toLowerCase()))
                .map((name) => utf8.encode(name))
                .toList()
                .expand((x) => x)
                .toList(),
          )
          .toString();
    }
  }

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Album artist.
  final artists = IsarLinks<Artist>();

  @Index(
    unique: true,
    composite: [CompositeIndex('title')],
  )
  late String _artistNamesHash;

  /// Album title
  @Index()
  String title;

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
