import 'package:isar/isar.dart';
import 'package:mpax_flutter/models/music_model.dart';

part 'playlist_model.g.dart';

/// Const name for the special [Playlist] contains all music.
/// There should be only one playlist using this name and always be.
const libraryPlaylistName = 'all_music_library_name';

/// Model of playlist.
///
/// Maintains a list of audio files, and information/property about playlist.
@Collection()
class Playlist {
  /// Constructor.
  Playlist();

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Playlist name, human readable name.
  ///
  /// Allow duplicate, works like foobar2000.
  ///
  /// There's a special playlist which contains all [Music] and acts like music
  /// library. That playlist's name should be a const value and all other
  /// playlists should not have a same name.
  /// When searching data, filter that playlist according to whether search in
  /// music library.
  /// Put that playlist in the same Playlist Isar schema because it's actually
  /// another playlist.
  /// Now name is set to [libraryPlaylistName].
  @Index()
  String name = '';

  /// All music.
  ///
  /// All [Music] link saved in must NOT be null.
  /// If so, we should check every time access them or keep observing.
  List<Id> musicList = <Id>[];

  Playlist makeGrowable() {
    return this..musicList = musicList.toList();
  }

  /// Whether is an empty playlist.
  bool get isEmpty => musicList.isEmpty;

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  bool contains(Music music) => musicList.contains(music.id);

  /// Add music to current playlist.
  /// No duplicate file path.
  Future<void> addMusic(Music music) async {
    if (contains(music)) {
      return;
    }
    musicList.add(music.id);
  }

  /// Add a list of audio model to playlist, not duplicate with same path file.
  Future<void> addMusicList(List<Music> musicList) async {
    for (final music in musicList) {
      if (contains(music)) {
        continue;
      }
      this.musicList.add(music.id);
    }
  }

  /// Remove [music] from current [Playlist].
  Future<void> removeMusic(Music music) async {
    musicList.removeWhere((m) => m == music.id);
  }

  /// Clear audio file list.
  void clearMusicList() {
    musicList.clear();
  }
}
