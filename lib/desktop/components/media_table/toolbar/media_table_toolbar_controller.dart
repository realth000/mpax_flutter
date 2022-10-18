import 'package:get/get.dart';

/// Controller of the header toolbar of audio table
class MediaTableToolbarController extends GetxController {
  /// Whether the column filters in audio table is visible.
  final searchEnabled = false.obs;

  /// Playlist name to display, readable name, not database table name.
  final playlistName = ''.obs;

  /// Record all checked row's file path in table.
  final checkedRowPathList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Every time when playlist changes, playlistName changes, and checked items
    // in table is cleared, so update list with this.
    ever(playlistName, (_) => checkedRowPathList.clear());
  }
}
