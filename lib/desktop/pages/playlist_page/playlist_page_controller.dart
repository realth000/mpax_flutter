import 'package:get/get.dart';

import '../../../models/playlist_model.dart';

/// Controller of playlist page.
class DesktopPlaylistPageController extends GetxController {
  /// Current showing playlist.
  final currentPlaylist = Playlist().obs;
}
