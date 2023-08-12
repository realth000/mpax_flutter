import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/widgets/entry_card.dart';

class PlaylistPage extends ConsumerStatefulWidget {
  const PlaylistPage({super.key});

  @override
  ConsumerState<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends ConsumerState<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.extent(
        children: [
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
          EntryCard(),
        ],
        maxCrossAxisExtent: 150,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        cacheExtent: 15,
      ),
    );
  }
}
