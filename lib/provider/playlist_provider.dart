import 'dart:math';

import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart' as model;
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_provider.g.dart';

class Playlist {
  Playlist(this.ref);

  Ref ref;

  model.Playlist? _playlist;

  Future<void> setPlaylist(model.Playlist playlist) async {
    _playlist = playlist;
    ref.read(appStateProvider.notifier).setCurrentPlaylistInfo(playlist.id);
    await ref.read(appSettingsProvider.notifier).setLastPlaylist(playlist.id);
  }

  Future<void> setPlaylistById(int id) async {
    final playlist =
        await ref.read(databaseProvider.notifier).findPlaylistById(id);
    if (playlist == null) {
      return;
    }
    _playlist = playlist;
    ref.read(appStateProvider.notifier).setCurrentPlaylistInfo(playlist.id);
    await ref.read(appSettingsProvider.notifier).setLastPlaylist(id);
  }

  Future<Music?> findPrevious(int id) async {
    if (_playlist == null) {
      return null;
    }

    final pos =
        _playlist!.musicList.firstWhere((e) => e == id, orElse: () => -1);
    if (pos == -1) {
      return null;
    }
    late final int targetId;
    if (pos == _playlist!.musicList.first) {
      targetId = _playlist!.musicList.last;
    } else {
      targetId = pos - 1;
    }

    return ref.read(databaseProvider.notifier).findMusicById(targetId);
  }

  Future<Music?> findNext(int id) async {
    if (_playlist == null) {
      return null;
    }

    final pos =
        _playlist!.musicList.firstWhere((e) => e == id, orElse: () => -1);
    if (pos == -1) {
      return null;
    }
    late final int targetId;
    if (pos == _playlist!.musicList.last) {
      targetId = _playlist!.musicList.first;
    } else {
      targetId = pos + 1;
    }

    return ref.read(databaseProvider.notifier).findMusicById(targetId);
  }

  Future<Music?> random() async {
    if (_playlist == null) {
      return null;
    }
    final targetId =
        _playlist!.musicList[Random().nextInt(_playlist!.musicList.length - 1)];
    return ref.read(databaseProvider.notifier).findMusicById(targetId);
  }
}

@Riverpod(keepAlive: true)
Playlist playlist(PlaylistRef ref) => Playlist(ref);
