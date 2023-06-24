import 'package:get/get.dart';

import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';

/// Service for searching in playlist, globally.
class SearchService extends GetxService {
  /// Search include text.
  String includeText = '';
  String _includeTextLowerCase = '';

  /// Search exclude text.
  String excludeText = '';
  String _excludeTextLowerCase = '';

  /// Search audio title
  final title = true.obs;

  /// Search audio artist.
  final artist = true.obs;

  /// Search album album title.
  final albumTitle = true.obs;

  /// Search album artist.
  ///
  /// In future, album artist may be a string list, not string,
  /// take care of this.
  final albumArtist = true.obs;

  /// Search audio file path, including file name.
  final contentPath = true.obs;

  /// Search audio file name.
  final contentName = true.obs;

  /// Indicate and control showing search page (false) and result page (true).
  final showResultPage = false.obs;

  /// Store search result
  final resultList = <Music>[].obs;

  /// Current searching playlist.
  final playlist = Playlist().obs;

  /// Init function, run before app start.
  Future<SearchService> init() async => this;

  bool _filterWithExclude(Music content) {
    // if (title.value &&
    //     content.title.toLowerCase().contains(_includeTextLowerCase) &&
    //     !content.title.toLowerCase().contains(_excludeTextLowerCase)) {
    //   return true;
    // }
    // if (artist.value &&
    //     content.artist.toLowerCase().contains(_includeTextLowerCase) &&
    //     !content.artist.toLowerCase().contains(_excludeTextLowerCase)) {
    //   return true;
    // }
    // if (albumTitle.value &&
    //     content.albumTitle.toLowerCase().contains(_includeTextLowerCase) &&
    //     !content.albumTitle.toLowerCase().contains(_excludeTextLowerCase)) {
    //   return true;
    // }
    // if (albumArtist.value &&
    //     content.albumArtist.toLowerCase().contains(_includeTextLowerCase) &&
    //     !content.albumArtist.toLowerCase().contains(_excludeTextLowerCase)) {
    //   return true;
    // }
    // if (contentPath.value &&
    //     content.filePath.toLowerCase().contains(_includeTextLowerCase) &&
    //     !content.filePath.toLowerCase().contains(_excludeTextLowerCase)) {
    //   return true;
    // }
    // if (contentName.value &&
    //     content.fileName.toLowerCase().contains(_includeTextLowerCase) &&
    //     !content.fileName.toLowerCase().contains(_excludeTextLowerCase)) {
    //   return true;
    // }
    return false;
  }

  bool _filter(Music content) {
    // if (title.value &&
    //     content.title.toLowerCase().contains(_includeTextLowerCase)) {
    //   return true;
    // }
    // if (artist.value &&
    //     content.artist.toLowerCase().contains(_includeTextLowerCase)) {
    //   return true;
    // }
    // if (albumTitle.value &&
    //     content.albumTitle.toLowerCase().contains(_includeTextLowerCase)) {
    //   return true;
    // }
    // if (albumArtist.value &&
    //     content.albumArtist.toLowerCase().contains(_includeTextLowerCase)) {
    //   return true;
    // }
    // if (contentPath.value &&
    //     content.filePath.toLowerCase().contains(_includeTextLowerCase)) {
    //   return true;
    // }
    // if (contentName.value &&
    //     content.fileName.toLowerCase().contains(_includeTextLowerCase)) {
    //   return true;
    // }
    return false;
  }

  /// Search in playlist by pattern.
  Future<void> search(
    String playlistTableName,
    String includeText,
    String excludeText,
  ) async {
    this.includeText = includeText;
    this.excludeText = excludeText;
    _includeTextLowerCase = includeText.toLowerCase();
    _excludeTextLowerCase = excludeText.toLowerCase();
    playlist.value = Get.find<MediaLibraryService>()
        .findPlaylistByTableName(playlistTableName);
    final resultList = <Music>[];
    if (this.excludeText.isEmpty) {
      for (final content in playlist.value.musicList) {
        if (_filter(content)) {
          resultList.add(content);
        }
      }
    } else {
      for (final content in playlist.value.musicList) {
        if (_filterWithExclude(content)) {
          resultList.add(content);
        }
      }
    }
    this.resultList.value = resultList;
  }
}
