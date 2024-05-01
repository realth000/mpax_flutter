import 'package:flutter/material.dart';

import 'package:mpax_flutter/i18n/strings.g.dart';

/// Page to show album categories.
///
/// Display info about of indexed albums.
final class AlbumPage extends StatefulWidget {
  /// Constructor.
  const AlbumPage({super.key});

  @override
  State<AlbumPage> createState() => _AlbumPage();
}

/// State of [AlbumPage].
final class _AlbumPage extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    final tr = context.t.playlistPage;
    return Center(child: Text(tr.title));
  }
}
