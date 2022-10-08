import 'package:get/get.dart';

import '../models/play_content.model.dart';
import '../models/playlist.model.dart';
import 'media_library_service.dart';

/// Service for searching in playlist, globally.
class SearchService extends GetxService {
  /// Search include text.
  String includeText = '';

  /// Search exclude text.
  String excludeText = '';

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
  final resultList = <PlayContent>[].obs;

  /// Current searching playlist.
  final playlist = PlaylistModel().obs;

  /// Init function, run before app start.
  Future<SearchService> init() async => this;

  bool _filterWithExclude(PlayContent content) {
    if (title.value &&
        content.title.contains(includeText) &&
        !content.title.contains(excludeText)) {
      return true;
    }
    if (artist.value &&
        content.artist.contains(includeText) &&
        !content.artist.contains(excludeText)) {
      return true;
    }
    if (albumTitle.value &&
        content.albumTitle.contains(includeText) &&
        !content.albumTitle.contains(excludeText)) {
      return true;
    }
    if (albumArtist.value &&
        content.albumArtist.contains(includeText) &&
        !content.albumArtist.contains(excludeText)) {
      return true;
    }
    if (contentPath.value &&
        content.contentPath.contains(includeText) &&
        !content.contentPath.contains(excludeText)) {
      return true;
    }
    if (contentName.value &&
        content.contentName.contains(includeText) &&
        !content.contentName.contains(excludeText)) {
      return true;
    }
    return false;
  }

  bool _filter(PlayContent content) {
    if (title.value && content.title.contains(includeText)) {
      return true;
    }
    if (artist.value && content.artist.contains(includeText)) {
      return true;
    }
    if (albumTitle.value && content.albumTitle.contains(includeText)) {
      return true;
    }
    if (albumArtist.value && content.albumArtist.contains(includeText)) {
      return true;
    }
    if (contentPath.value && content.contentPath.contains(includeText)) {
      return true;
    }
    if (contentName.value && content.contentName.contains(includeText)) {
      return true;
    }
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
    playlist.value = Get.find<MediaLibraryService>()
        .findPlaylistByTableName(playlistTableName);
    final resultList = <PlayContent>[];
    if (this.excludeText.isEmpty) {
      for (final content in playlist.value.contentList) {
        if (_filter(content)) {
          resultList.add(content);
        }
      }
    } else {
      for (final content in playlist.value.contentList) {
        if (_filterWithExclude(content)) {
          resultList.add(content);
        }
      }
    }
    this.resultList.value = resultList;
  }
}
