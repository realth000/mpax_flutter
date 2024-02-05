import 'package:realm/realm.dart';

part '../generated/models/artist_model.g.dart';

/// Artist model.
@RealmModel()
class _Artist {
  /// Artist name, should be unique.
  @PrimaryKey()
  late final String name;

  late List<int> musicList;

  /// All albums related.
  late List<int> albumList;
}
