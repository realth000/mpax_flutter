import 'package:realm/realm.dart';

part '../generated/models/playlist_model.g.dart';

/// Const name for the special [_Playlist] contains all music.
/// There should be only one playlist using this name and always be.
const libraryPlaylistName = 'all_music_library_name';

/// Model of playlist.
///
/// Maintains a list of audio files, and information/property about playlist.
@PrimaryKey()
class _Playlist {
  /// Playlist name, human readable name.
  ///
  /// Allow duplicate, works like foobar2000.
  ///
  /// There's a special playlist which contains all Music and acts like music
  /// library. That playlist's name should be a const value and all other
  /// playlists should not have a same name.
  /// When searching data, filter that playlist according to whether search in
  /// music library.
  /// Put that playlist in the same Playlist Isar schema because it's actually
  /// another playlist.
  /// Now name is set to [libraryPlaylistName].
  @PrimaryKey()
  late final String name;

  /// All music.
  ///
  /// All Music link saved in must NOT be null.
  /// If so, we should check every time access them or keep observing.
  late List<int>? musicIdList;

  late int? coverArtworkId;
}
