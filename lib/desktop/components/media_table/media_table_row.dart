import 'package:get/get.dart';

import '../../../models/music_model.dart';

/// A row in [MediaTable]
class MediaRow {
  /// Constructor.
  MediaRow(
    this.music, {
    bool selected = false,
  }) {
    this.selected.value = selected;
  }

  /// Music to display.
  Music music;

  /// Whether this row is selected.
  final selected = false.obs;
}
