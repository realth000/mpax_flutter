import 'package:get/get.dart';

import 'package:mpax_flutter/models/playlist_model.dart';

/// Controller of playlist page.
class DesktopPlaylistPageController extends GetxController {
  /// Current showing playlist.
  final currentPlaylist = Playlist().obs;
}
