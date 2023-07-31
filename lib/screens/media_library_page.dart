import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/widgets/audio_list.dart';

class MediaLibraryPage extends ConsumerStatefulWidget {
  const MediaLibraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MediaLibraryPageState();
}

class _MediaLibraryPageState extends ConsumerState<MediaLibraryPage> {
  @override
  Widget build(BuildContext context) {
    return AudioList(libraryPlaylistName);
  }
}
