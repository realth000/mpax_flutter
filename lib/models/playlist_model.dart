import 'dart:math';

import 'package:isar/isar.dart';

import 'music_model.dart';

/// Model of playlist.
///
/// Maintains a list of audio files, and information/property about playlist.
@Collection()
class PlaylistModel {
  /// Constructor.
  PlaylistModel();

  /// Id in database.
  Id id = Isar.autoIncrement;

  /// Playlist name, human readable name.
  String name = '';

  /// All music.
  ///
  /// Do not use [IsarLinks] because we want to keep [musicList] sorted.
  /// And all [Music] link saved in must NOT be null.
  /// TODO: Check whether deleting a [Music] will leave an empty [IsarLink].
  /// If so, we should check every time access them or keep observing.
  final musicList = <IsarLink<Music>>[];

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  // TODO: Maybe should implement this with database.
  bool contains(Music music) {
    for (final content in musicList.where((link) => link.value != null)) {
      if (content.value!.filePath == music.filePath) {
        return true;
      }
    }
    return false;
  }

  /// Tell if the specified path file already exists in playlist.
  // TODO: Maybe should implement this with database.
  Music? find(String contentPath) {
    for (final content in musicList.where((link) => link.value != null)) {
      if (content.value!.filePath == contentPath) {
        return content.value;
      }
    }
    return null;
  }

  /// Add a list of audio model to playlist, not duplicate with same path file.
  void addMusicList(List<Music> musicList) {
    for (final content in musicList) {
      // TODO: Maybe [IsarLink] is similar to [Set], which means we do not need to prevent repeat.
      if (contains(content)) {
        continue;
      }
      musicList.add(content);
    }
  }

  /// Clear audio file list.
  void clearMusicList() {
    musicList.clear();
  }

  /// Find previous audio content of the given playContent.
  ///
  /// If it's the first one, the last one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findPreviousMusic(Music playContent) {
    if (musicList.isEmpty) {
      return null;
    }
    if (musicList.first.value!.filePath == playContent.filePath) {
      return musicList.last.value;
    }
    for (var i = musicList.length - 1; i > -1; i--) {
      if (musicList[i].value?.filePath == playContent.filePath) {
        // FIXME: May return null here.
        return musicList[i - 1].value;
      }
    }
    return musicList.first.value;
  }

  /// Find next audio content of the given playContent.
  ///
  /// If it's the last one, the first one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music? findNextContent(Music playContent) {
    if (musicList.isEmpty) {
      return null;
    }
    if (musicList.last.value!.filePath == playContent.filePath) {
      return musicList.first.value;
    }
    for (var i = 0; i < musicList.length; i++) {
      if (musicList[i].value?.filePath == playContent.filePath) {
        return musicList[i + 1].value;
      }
    }
    return musicList.first.value;
  }

  /// Return a random audio content in playlist.
  Music? randomPlayContent() {
    if (musicList.isEmpty) {
      return null;
    }
    return musicList[Random().nextInt(musicList.length)].value;
  }

  /// Remove same [Music] with same [filePathList].
  Future<void> removeByPathList(List<String> filePathList) async {
    musicList.removeWhere(
      (content) => filePathList.contains(content.value!.filePath),
    );
  }
}
