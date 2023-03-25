import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/music_model.dart';
import '../models/playlist_model.dart';

/// Controller of [MediaList]
/// Control load data.
class MediaListController extends GetxController {
  /// Constructor.
  MediaListController(this.playlist) {
    it = playlist.musicList.iterator;
    _fetchMediaData();
    print(
        'AAAA construct MediaListController: length = ${playlist.musicList.length}');
  }

  /// [Playlist] contains all data.
  final Playlist playlist;

  /// [Iterator] of [playlist].
  late final Iterator<Music> it;

  /// [Playlist] to show.
  final showList = <Music>[];

  /// Controller of MediaList scrolling.
  final scrollController = ScrollController();

  /// Add how many media items to MediaList every time _fetchMediaData.
  final increaseCount = 20;

  /// Current items count in MediaList.
  int currentCount = 20;

  void _fetchMediaData() {
    var count = 0;
    for (; count < increaseCount && it.moveNext(); count++) {
      showList.add(it.current);
    }
    currentCount += count;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _fetchMediaData();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
