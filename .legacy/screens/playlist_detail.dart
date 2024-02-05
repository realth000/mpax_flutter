import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/widgets/audio_list.dart';

class PlaylistDetailPage extends ConsumerWidget {
  const PlaylistDetailPage({this.routerState, super.key});

  final GoRouterState? routerState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (routerState == null) {
      return const AudioList(libraryPlaylistName);
    } else if (routerState!.extra == null) {
      return const Text('router extra args is null');
    }
    final argsMap = routerState!.extra! as Map<String, dynamic>;
    return AudioList(argsMap['playlistName'] as String);
  }
}
