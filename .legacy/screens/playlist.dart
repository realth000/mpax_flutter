import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/scanner_provider.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/utils/debug.dart';
import 'package:mpax_flutter/utils/shimmer_widget.dart';
import 'package:mpax_flutter/widgets/entry_card.dart';

enum PlaylistMenuAction {
  addMusic,
  delete,
  info,
}

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
      child: FutureBuilder(
        future: ref.read(databaseProvider).allPlaylist(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          final allPlaylist = snapshot.data!;

          return GridView.builder(
            itemCount: allPlaylist.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 140,
            ),
            itemBuilder: (context, index) => FutureBuilder(
              future: ref
                  .read(databaseProvider)
                  .fetchArtworkDataById(allPlaylist[index].coverArtworkId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else if (snapshot.connectionState != ConnectionState.done) {
                  return Shimmer(
                    linearGradient: ShimmerGradiant.of(context),
                    child: const ShimmerLoading(
                      isLoading: true,
                      child: Card(),
                    ),
                  );
                }

                final playlist = allPlaylist[index];

                return EntryCard(
                  cover: snapshot.data != null
                      ? Image.memory(snapshot.data!)
                      : null,
                  defaultCover: const Icon(Icons.queue_music),
                  description: allPlaylist[index].name,
                  onTap: () {
                    context.push(
                      '${ScreenPaths.playlist}/detail/${playlist.id}',
                      extra: <String, dynamic>{
                        'appBarTitle': playlist.name,
                        'playlistId': playlist.id,
                        'playlistName': playlist.name,
                        'playlistMusicList': playlist.musicList,
                      },
                    );
                  },
                  popupMenuItemBuilder: (context) =>
                      const <PopupMenuItem<PlaylistMenuAction>>[
                    PopupMenuItem(
                      child: Text('Add Music'),
                      value: PlaylistMenuAction.addMusic,
                    ),
                    PopupMenuItem(
                      child: Text('Delete'),
                      value: PlaylistMenuAction.delete,
                    ),
                    PopupMenuItem(
                      child: Text('Info'),
                      value: PlaylistMenuAction.info,
                    ),
                  ],
                  popupMenuOnSelected: (v) async {
                    switch (v) {
                      case PlaylistMenuAction.addMusic:
                        final targetPath =
                            await FilePicker.platform.getDirectoryPath();
                        if (targetPath == null) {
                          return;
                        }
                        final ret =
                            await ref.read(scannerProvider.notifier).scan(
                          playlistId: playlist.id,
                          paths: [targetPath],
                        );
                        debug('add success');
                      case PlaylistMenuAction.delete:
                      // TODO: delete
                      case PlaylistMenuAction.info:
                        if (!mounted) {
                          return;
                        }
                        await context.push(
                          '${ScreenPaths.playlist}/info/${playlist.id}',
                          extra: <String, dynamic>{
                            'appBarTitle': 'Playlist Info',
                            'playlistId': playlist.id,
                            'playlistName': playlist.name,
                            'playlistMusicList': playlist.musicList,
                          },
                        );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

AppBarActionsBuilder playlistPageActionsBuilder = (context, ref) {
  return [
    IconButton(
      onPressed: () async {
        final result = await showDialog<(bool, String?)>(
          context: context,
          builder: (context) {
            final key = GlobalKey<FormState>();
            final nameController = TextEditingController();

            return AlertDialog(
              scrollable: true,
              title: const Text('Create Playlist'),
              content: Form(
                key: key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Playlist Name',
                      ),
                      validator: (v) => v!.trim().isNotEmpty
                          ? null
                          : 'Playlist name should not be empty',
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, (false, ''));
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (key.currentState == null ||
                        !(key.currentState!).validate()) {
                      return;
                    }
                    Navigator.pop(context, (true, nameController.text));
                  },
                  child: const Text('Ok'),
                ),
              ],
            );
          },
        );

        if (result == null) {
          return;
        }

        final create = result.$1;
        if (!create) {
          return;
        }

        final name = result.$2;
        await ref.read(databaseProvider).savePlaylist(Playlist()..name = name!);
      },
      icon: const Icon(Icons.playlist_add),
    ),
    IconButton(
      onPressed: () {},
      icon: const Icon(Icons.tune),
    ),
  ];
};
