import 'dart:math';

import 'play_content.model.dart';

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
  List<PlayContent> contentList = <PlayContent>[];

  /// Id used in database, means nothing without database.
  static int id = -1;

  /// Tell if the specified audio file already exists in playlist.
  ///
  /// Run by file path.
  bool contains(PlayContent playContent) {
    for (final content in contentList) {
      if (content.contentPath == playContent.contentPath) {
        return true;
      }
    }
    return false;
  }

  /// Tell if the specified path file already exists in playlist.
  PlayContent? find(String contentPath) {
    for (final content in contentList) {
      if (content.contentPath == contentPath) {
        return content;
      }
    }
    return null;
  }

  /// Add a list of audio model to playlist, not duplicate with same path file.
  void addContentList(List<PlayContent> playContentList) {
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
  PlayContent findPreviousContent(PlayContent playContent) {
    if (contentList.isEmpty) {
      return PlayContent();
    }
    if (contentList.first.contentPath == playContent.contentPath) {
      return contentList.last;
    }
    for (var i = contentList.length - 1; i > -1; i--) {
      if (contentList[i].contentPath == playContent.contentPath) {
        return contentList[i - 1];
      }
    }
    return contentList.first;
  }

  /// Find next audio content of the given playContent.
  ///
  /// If it's the last one, the first one will be returned.
  /// Find current playContent position by [contentList.last.contentPath].
  PlayContent findNextContent(PlayContent playContent) {
    if (contentList.isEmpty) {
      return PlayContent();
    }
    if (contentList.last.contentPath == playContent.contentPath) {
      return contentList.first;
    }
    for (var i = 0; i < contentList.length; i++) {
      if (contentList[i].contentPath == playContent.contentPath) {
        return contentList[i + 1];
      }
    }
    return contentList.first;
  }

  /// Convert to map format, sqflite need this.
  Map<String, dynamic> toMap() {
    id++;
    return {
      'id': id,
      'sort': contentList.length,
      'playlist_name': name,
      'table_name': tableName,
    };
  }

  /// Return a random audio content in playlist.
  PlayContent randomPlayContent() {
    if (contentList.isEmpty) {
      return PlayContent();
    }
    return contentList[Random().nextInt(contentList.length)];
  }
}
