import 'package:flutter/material.dart';

import '../../../i18n/strings.g.dart';

/// Page to show artist categories.
///
/// Display all info of indexed artists.
final class ArtistPage extends StatefulWidget {
  /// Constructor.
  const ArtistPage({super.key});

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

/// State of [ArtistPage].
final class _ArtistPageState extends State<ArtistPage> {
  @override
  Widget build(BuildContext context) {
    final tr = context.t.artistPage;
    return Center(child: Text(tr.title));
  }
}
