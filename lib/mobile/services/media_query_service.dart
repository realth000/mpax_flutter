import 'dart:convert';

import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart' as aq;

import '../../models/music_model.dart';

/// Use media store on Android, provide fast music library load.
class MediaQueryService extends GetxService {
  final _audioQuery = aq.OnAudioQuery();

  /// Contains all audio info from Android media store.
  late final List<aq.AudioModel> audioList;

  /// Contains all artist info from Android media store.
  late final List<aq.ArtistModel> artistList;

  /// Contains all album info from Android media store.
  late final List<aq.AlbumModel> albumList;

  /// Contains all playlist from Android media store.
  late final List<aq.PlaylistModel> playlistList;

  /// Request permissions.
  Future<void> requestPermissions() async {
    if (!await _audioQuery.permissionsStatus()) {
      await _audioQuery.permissionsRequest();
    }
  }

  /// Reload all kinds of info from Android media store.
  Future<void> reloadAllMedia() async {
    await requestPermissions();
    audioList = await _audioQuery.queryAudios();
    artistList = await _audioQuery.queryArtists();
    // FIXME: Query albums should not throw exception "null is not sub type of int".
    // albumList = await _audioQuery.queryAlbums();
    playlistList = await _audioQuery.queryPlaylists();
  }

  /// Return a list of [Music] contains all audios in media store.
  /// Some audio properties should load later by tag readers.
  Future<List<Music>> allAudioContents() async {
    final contentList = <Music>[];
    // TODO: Construct from Android media query result here.
    /*
    for (final audio in audioList) {
      contentList.add(
        Music.fromData(
          audio.data,
          audio.displayName,
          audio.size,
          audio.artist ?? '',
          audio.title,
          audio.track ?? 0,
          // bitrate
          0,
          // albumArtist
          '',
          audio.album ?? '',
          // albumYear
          0,
          // albumTrackCount
          0,
          audio.genre ?? '',
          // comment
          '',
          // sampleRate
          0,
          // channels
          0,
          audio.duration ?? 0,
          // albumCover
          '',
        ),
      );
    }
     */
    return contentList;
  }

  /// Init function, run before app start.
  Future<MediaQueryService> init() async {
    await reloadAllMedia();
    return this;
  }

  Future<String> loadAlbumCover(aq.AudioModel audio) async {
    var cover = await _audioQuery.queryArtwork(audio.id, aq.ArtworkType.AUDIO);
    cover ??= await _audioQuery.queryArtwork(audio.id, aq.ArtworkType.ALBUM);
    var coverBase64 = '';
    if (cover != null && cover.artwork != null) {
      coverBase64 = base64Encode(cover.artwork!);
    }
    return coverBase64;
  }
}
