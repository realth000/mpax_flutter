import 'package:flutter/material.dart';

/// Music library UI page.
final class MusicLibraryPage extends StatefulWidget {
  /// Constructor.
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

final class _MusicLibraryPageState extends State<MusicLibraryPage> {
  @override
  Widget build(BuildContext context) {
    return const Text('Music library page');
  }
}
