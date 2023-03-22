import 'dart:math';

import 'music_model.dart';

/// Model of playlist.
///
/// Maintains a list of audio files, and information/property about playlist.
class PlaylistModel {
  /// Constructor.
  PlaylistModel();

  /// Construct by info and audio content list.
  PlaylistModel.fromInfo(this.name, this.tableName, this.contentList);

  /// Playlist name, human readable name.
  String name = '';

  /// Playlist name only used with database to tell difference from other same
  /// [name] playlists, usually not display on UI.
  String tableName = '';

  /// Audio models list.
  List<Music> contentList = <Music>[];

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  bool contains(Music playContent) {
    for (final content in contentList) {
      if (content.filePath == playContent.filePath) {
        return true;
      }
    }
    return false;
  }

  /// Tell if the specified path file already exists in playlist.
  Music? find(String contentPath) {
    for (final content in contentList) {
      if (content.filePath == contentPath) {
        return content;
      }
    }
    return null;
  }

  /// Add a list of audio model to playlist, not duplicate with same path file.
  void addContentList(List<Music> playContentList) {
    for (final content in playContentList) {
      if (contains(content)) {
        continue;
      }
      contentList.add(content);
    }
  }

  /// Clear audio file list.
  void clearContent() {
    contentList.clear();
  }

  /// Find previous audio content of the given playContent.
  ///
  /// If it's the first one, the last one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music findPreviousContent(Music playContent) {
    if (contentList.isEmpty) {
      return Music();
    }
    if (contentList.first.filePath == playContent.filePath) {
      return contentList.last;
    }
    for (var i = contentList.length - 1; i > -1; i--) {
      if (contentList[i].filePath == playContent.filePath) {
        return contentList[i - 1];
      }
    }
    return contentList.first;
  }

  /// Find next audio content of the given playContent.
  ///
  /// If it's the last one, the first one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  Music findNextContent(Music playContent) {
    if (contentList.isEmpty) {
      return Music();
    }
    if (contentList.last.filePath == playContent.filePath) {
      return contentList.first;
    }
    for (var i = 0; i < contentList.length; i++) {
      if (contentList[i].filePath == playContent.filePath) {
        return contentList[i + 1];
      }
    }
    return contentList.first;
  }

  /// Return a random audio content in playlist.
  Music randomPlayContent() {
    if (contentList.isEmpty) {
      return Music();
    }
    return contentList[Random().nextInt(contentList.length)];
  }

  /// Remove same [Music] with same [filePathList].
  Future<void> removeByPathList(List<String> filePathList) async {
    contentList
        .removeWhere((content) => filePathList.contains(content.filePath));
  }
}
