import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';

/// Page to show playlist categories.
///
/// Display all saved playlists info.
final class PlaylistPage extends StatefulWidget {
  /// Constructor.
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

/// State of [PlaylistPage].
final class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    final tr = context.t.playlistPage;
    return Center(child: Text(tr.title));
  }
}
