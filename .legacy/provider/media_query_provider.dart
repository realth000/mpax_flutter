import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../generated/provider/media_query_provider.g.dart';

class MediaQuery {
  MediaQuery(this.ref);

  Ref ref;

  late final _audioQuery = OnAudioQuery();

  late List<SongModel> mediaList;

  /// Request permissions.
  Future<void> requestPermissions() async {
    if (!await _audioQuery.permissionsStatus()) {
      await _audioQuery.permissionsRequest();
    }
  }

  Future<void> reloadAllMedia() async {
    await requestPermissions();
    mediaList = await _audioQuery.querySongs();
  }

  Future<List<Music>> allMedia() async {
    final database = ref.read(databaseProvider);
    final ret = <Music>[];

    for (final media in mediaList) {
      // Media
      final f = File(media.data);
      final filePath = f.path;
      final fileName = basename(filePath);
      final fileSize = f.lengthSync();
      final music = await database.findMusicByFilePath(filePath) ??
          await database.fetchMusic(filePath);
      final artist = await database.findArtistByName(media.artist);
      final album = await database.findAlbumByTitle(media.album ?? '');

      music
        ..fileName = fileName
        ..fileSize = fileSize
        ..title = media.title
        ..album = album != null ? album.id : 0
        ..trackNumber = media.track ?? 0
        ..genre = media.genre ?? '';

      if (artist != null) {
        music.artistList.add(artist.id);
      }
      ret.add(music);
    }

    return ret;
  }
}

@Riverpod(keepAlive: true)
MediaQuery mediaQuery(MediaQueryRef ref) => MediaQuery(ref);
