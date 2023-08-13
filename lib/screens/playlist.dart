import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/router.dart';
import 'package:mpax_flutter/utils/shimmer_widget.dart';
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
      child: FutureBuilder(
        future: ref.read(databaseProvider.notifier).allPlaylist(),
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
                  .read(databaseProvider.notifier)
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
                return EntryCard(
                  cover: snapshot.data != null
                      ? Image.memory(snapshot.data!)
                      : null,
                  defaultCover: const Icon(Icons.queue_music),
                  description: allPlaylist[index].name,
                  onTap: () {
                    context.push(
                      '${ScreenPaths.playlist}/${allPlaylist[index].id}',
                      extra: <String, dynamic>{
                        'appBarTitle': allPlaylist[index].name,
                        'playlistId': allPlaylist[index].id,
                        'playlistName': allPlaylist[index].name,
                        'playlistMusicList': allPlaylist[index].musicList,
                      },
                    );
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
        await ref
            .read(databaseProvider.notifier)
            .savePlaylist(Playlist()..name = name!);
      },
      icon: const Icon(Icons.playlist_add),
    ),
    IconButton(
      onPressed: () {},
      icon: const Icon(Icons.tune),
    ),
  ];
};
