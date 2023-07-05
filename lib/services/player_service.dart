import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';
import 'package:mpax_flutter/services/settings_service.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_audio/simple_audio.dart';

/// In charge of playing audio file, globally.
class PlayerService extends GetxService {
  //PlayerService({this.wrapper});
  PlayerService();

  // State
  static const IconData _playIcon = Icons.play_arrow;
  static const IconData _pauseIcon = Icons.pause;
  static const IconData _repeatIcon = Icons.repeat;
  static const _repeatString = 'Repeat';
  static const _repeatOneString = 'RepeatOne';
  static const _shuffleString = 'Shuffle';
  static const IconData _repeatOneIcon = Icons.repeat_one;
  static const IconData _shuffleIcon = Icons.shuffle;

  final _configService = Get.find<SettingsService>();
  final _libraryService = Get.find<MediaLibraryService>();
  final _metadataService = Get.find<MetadataService>();
  final _databaseService = Get.find<DatabaseService>();
  final _player = SimpleAudio();

  /// Play history, only uses in shuffle mode([playMode] == [_shuffleString]).
  /// Usage and behavior act like foobar2000's play history.
  ///
  /// In the following situations, this history list will append items:
  /// * In shuffle mode, and caller is a "seek to next" action, not "play xxx"
  /// audio".
  ///
  /// In the following situations, use this history list:
  /// * In shuffle mode, and caller is a "seek to previous" action, not "play
  /// xxx audio" and current playing position is not head or tail of history
  /// list.
  ///
  /// In the following situations, the history will clear all items:
  /// * Caller is "play xxx audio", no matter in shuffle mode or not.
  /// * Switch to another playlist.
  ///
  /// Every time when [playHistoryList] changes, update [playHistoryPos]
  /// because current playing position is updated.
  final playHistoryList = <Music>[];

  /// Current position in [playHistoryList].
  ///
  /// Decide previous one audio and next one audio according to this position.
  /// When finding previous or next audio in [playHistoryList], move this pos.
  /// If [playHistoryList] grows (at tail), set to tail after growth.
  /// If [playHistoryList] clears, reset playHistoryPos to initial value (-1).
  var playHistoryPos = -1;

  /// Current playing position.
  final currentPosition = Duration.zero.obs;

  /// Current duration position.
  final currentDuration = const Duration(seconds: 1).obs;

  /// Player volume
  ///
  /// [0, 1], 0 == mute, 1 == max volume.
  final volume = 0.3.obs;

  /// Record last not mute volume.
  ///
  /// Before mute, record the [volume] value.
  /// After unmute, set [volume] to this value.
  double volumeBeforeMute = 0.3;

  /// Current playing playlist.
  Playlist currentPlaylist = Playlist();

  /// Current playing content.
  final currentMusic = Music().obs;

  /// Current play mode.
  String playMode = _repeatString;

  /// Show on play or pause.
  Rx<IconData> playButtonIcon = _playIcon.obs;

  /// Show play mode.
  Rx<IconData> playModeIcon = _repeatIcon.obs;

  // late final StreamSubscription<ProcessingState> _playerDurationStream;

  /// Set and save player volume.
  Future<void> saveVolume(double volume) async {
    if (volume > 1) {
      return;
    }
    await _player.setVolume(volume);
    this.volume.value = volume;
    await Get.find<SettingsService>().saveDouble('PlayerVolume', volume);
  }

  /// Init function, run before app start.
  Future<PlayerService> init() async {
    final v = Get.find<SettingsService>().getDouble('PlayerVolume');
    if (v != null) {
      volume.value = v;
      volumeBeforeMute = v;
      await _player.setVolume(volume.value);
    }
    _player.playbackStateStream.listen((event) async {
      switch (event) {
        case PlaybackState.done:
          if (playMode == _repeatOneString) {
            currentMusic.value.lyrics =
                await _metadataService.loadLyrics(currentMusic.value);
            await _player.open(currentMusic.value.filePath);
            await _player.play();
          } else {
            await seekToAnother(true);
          }
          break;
        case PlaybackState.play:
          playButtonIcon.value = _pauseIcon;
          break;
        case PlaybackState.pause:
          playButtonIcon.value = _playIcon;
          break;
      }
    });
    _player.progressStateStream.listen((event) {
      currentPosition.value = event.position.seconds;
      currentDuration.value = event.duration.seconds;
    });
    // Load configs.
    playMode = _configService.getString('PlayMode') ?? _repeatString;
    await switchPlayMode(playMode);
    return this;
  }

  /// Load init media content form config.
  ///
  /// Separate this because this step can also be done after UI setup and if
  /// running too early cause error in other services init.
  Future<void> loadInitMedia() async {
    final currentMedia = File(_configService.getString('CurrentMedia') ?? '');
    if (!currentMedia.existsSync()) {
      return;
    }
    // FIXME: Add current playlist config save and load.
    final currentPlaylistId = _configService.getInt('CurrentPlaylistId') ?? 0;
    final currentPlaylist =
        await _libraryService.findPlaylistById(currentPlaylistId);
    if (currentPlaylist == null) {
      return;
    }
    final content =
        await _databaseService.findMusicByFilePath(currentMedia.path);
    if (content != null) {
      await setCurrentContent(content, currentPlaylist);
    }
  }

  /// Change current playing audio to given [playContent], and current playing
  /// list to [playlist].
  ///
  /// This set to be a public function for UI widgets to control current playing
  /// audio, control command looks like "play file:///a/b/c.mp3", not looks like
  /// "play the previous/next music in current playlist". The latter one should
  /// call [seekToAnother].
  ///
  /// Also clear [playHistoryList]. If do not want to clear [playHistoryList],
  /// use [_setCurrentPathToPlayer].
  Future<void> setCurrentContent(
    Music playContent,
    Playlist playlist,
  ) async {
    await _setCurrentPathToPlayer(playContent, playlist);
    // Clear play history no matter in shuffle play mode or not,
    // because the caller is a "play xxx audio" action.
    playHistoryList.clear();
    playHistoryPos = -1;
    // If in shuffle mode, record [playContent] as the history head.
    if (playMode == _shuffleString) {
      playHistoryList.add(playContent);
      playHistoryPos = playHistoryList.length - 1;
    }
  }

  /// Set current playing audio to given [Music]
  /// and do not clear [playHistoryList].
  /// If want to both set audio and clean [playHistoryList],
  /// use [setCurrentContent].
  Future<void> _setCurrentPathToPlayer(
    Music music,
    Playlist playlist,
  ) async {
    // Read the full album cover image to display in music page.
    // final p = await _metadataService.readMetadata(
    await music.refreshMetadata(
      loadImage: true,
      scaleImage: false,
      fast: false,
    );
    music.lyrics = await _metadataService.loadLyrics(music) ?? '';
    //final c = music.artworkList.first.artwork.value?.data;
    //await _player.setSourceDeviceFile(music.filePath);
    await _player.open(music.filePath);

    // Save scaled album cover in file for the just_audio_background service to
    // display on android control center.
    final hasCoverImage = currentMusic.value.artworkList.isNotEmpty;
    await clearCoverImageCache();
    final coverFile = File(
      '${(await getTemporaryDirectory()).path}/cover.cache.${DateTime.now().microsecondsSinceEpoch.toString()}',
    );
    if (hasCoverImage) {
      await coverFile.writeAsBytes(
        base64Decode(_databaseService.findArtworkDataByTypeIdSync(
            currentMusic.value.artworkList.first)!),
        flush: true,
      );
    }

    await _player.setMetadata(
      Metadata(
        title: music.title ?? '',
        artist:
            await _databaseService.findArtistNamesByIdList(music.artistList),
        album: await _databaseService.findAlbumTitleById(music.album),
        artUri: hasCoverImage ? coverFile.path : '',
      ),
    );
    currentMusic.value = music;
    currentPlaylist = playlist;
    if (GetPlatform.isMobile) {
      // FIXME: The stop and play action here is to fix notification art image
      // not update on some Android versions (e.g. MIUI).
      // I can not find the root cause but this action can fix the problem.
      // Need further solution in future.
      // 雷军？金凡！
      //if (GetPlatform.isAndroid && _player.state == PlayerState.playing) {
      //  await stop();
      //  await play();
      //}
    }
    await _configService.saveString(
      'CurrentMedia',
      currentMusic.value.filePath,
    );
    // TODO: Update current playlist here.
    await _configService.saveInt(
      'CurrentPlaylistId',
      currentPlaylist.id,
    );
  }

  /// Start play.
  Future<void> play() async {
    // Use for debugging.
    // await _player.seek(Duration(seconds: (_player.duration!.inSeconds * 0.98)
    // .toInt()));
    //await _player.play(DeviceFileSource(currentMusic.value.filePath));
    await _player.play();
  }

  /// Play when paused, pause when playing.
  Future<void> playOrPause() async {
    if (await _player.isPlaying) {
      await _player.pause();
      return;
    } else if (currentMusic.value.filePath.isNotEmpty) {
      await _player.play();
      return;
    } else {
      // Not a good state.
    }
  }

  /// Stop playing.
  Future<void> stop() async {
    await _player.stop();
  }

  /// Change play mode.
  Future<void> switchPlayMode([String? mode]) async {
    if (mode != null) {
      if (mode == _repeatString) {
        playModeIcon.value = _repeatIcon;
        playMode = _repeatString;
        return;
      } else if (mode == _repeatOneString) {
        playModeIcon.value = _repeatOneIcon;
        playMode = _repeatOneString;
        return;
      } else if (mode == _shuffleString) {
        playModeIcon.value = _shuffleIcon;
        playMode = _shuffleString;
        return;
      }
    }
    if (playModeIcon.value == _repeatIcon) {
      playModeIcon.value = _repeatOneIcon;
      await _configService.saveString('PlayMode', _repeatOneString);
      playMode = _repeatOneString;
    } else if (playModeIcon.value == _repeatOneIcon) {
      playModeIcon.value = _shuffleIcon;
      await _configService.saveString('PlayMode', _shuffleString);
      playMode = _shuffleString;
    } else {
      playModeIcon.value = _repeatIcon;
      await _configService.saveString('PlayMode', _repeatString);
      playMode = _repeatString;
    }
  }

  /// Seek to another audio content in [currentPlaylist].
  ///
  /// This set to be a public function for UI widgets to control current playing
  /// audio, control command looks like "play the previous/next music in current
  /// playlist", not looks like "play file:///a/b/c.mp3". The latter one should
  /// call [setCurrentContent].
  ///
  /// If [isNext] is true, play the next (forward) one in [currentPlaylist].
  /// If [isNext] is false, play previous (backward) one in [currentPlaylist].
  Future<void> seekToAnother(bool isNext) async {
    if (isNext) {
      switch (playMode) {
        case _shuffleString:
          if (playHistoryList.isNotEmpty) {
            if (playHistoryPos < playHistoryList.length - 1) {
              // If play history is not empty and play history position not the
              // end of history list, just move to the forward one.
              playHistoryPos++;
              await _setCurrentPathToPlayer(
                playHistoryList[playHistoryPos],
                currentPlaylist,
              );
              await play();
              return;
            }
          }
          // Reach here only when play history is empty or position is already
          // the tail of list.
          // Need to grow history list.
          final c = currentPlaylist.randomPlayContent();
          if (c == null) {
            await play();
            return;
          }
          await _setCurrentPathToPlayer(c, currentPlaylist);
          playHistoryList.add(c);
          playHistoryPos = playHistoryList.length - 1;
          // For test
          // final d = await _player.load();
          // if (d != null) {
          //   await _player.seek(Duration(seconds: d.inSeconds - 3));
          // }
          await play();
          break;
        case _repeatString:
        case _repeatOneString:
        default:
          final content = currentPlaylist.findNextContent(currentMusic.value);
          if (content == null) {
            return;
          }
          await setCurrentContent(content, currentPlaylist);
          // For test
          // final d = await _player.load();
          // if (d != null) {
          //   await _player.seek(Duration(seconds: d.inSeconds - 3));
          // }
          await play();
      }
    } else {
      switch (playMode) {
        case _shuffleString:
          if (playHistoryList.isNotEmpty) {
            if (playHistoryPos > 0) {
              // If play history is not empty and play history position not the
              // head of history list, just move to the backward one.
              playHistoryPos--;
              await _setCurrentPathToPlayer(
                playHistoryList[playHistoryPos],
                currentPlaylist,
              );
              await play();
              return;
            }
          }
          final c = currentPlaylist.randomPlayContent();
          if (c == null) {
            await play();
            return;
          }
          await _setCurrentPathToPlayer(c, currentPlaylist);
          playHistoryList.insert(0, c);
          playHistoryPos = 0;
          await play();
          break;
        case _repeatString:
        case _repeatOneString:
        default:
          final content = currentPlaylist.findPreviousMusic(currentMusic.value);
          if (content == null) {
            return;
          }
          await setCurrentContent(content, currentPlaylist);
          await play();
      }
    }
  }

  /// Jump to given [duration].
  Future<void> seekToDuration(Duration duration) async {
    //await _player.seek(duration);
    await _player.seek(duration.inSeconds);
  }

  /// Return current curation.
  // Future<Duration?> playerDuration() => _player.getDuration();

  /// Clear tmp cover image files.
  ///
  /// Only cache on Android, so this clean function also only usable on Android.
  Future<void> clearCoverImageCache() async {
    final cacheDir = Directory((await getTemporaryDirectory()).path);
    // All cover image cache are named with cover.cache.*
    await for (final e in cacheDir.list()) {
      if (e is File && basename(e.path).startsWith('cover.cache.')) {
        await e.delete();
      }
    }
  }
}
