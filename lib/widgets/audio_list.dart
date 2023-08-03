import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/player_provider.dart';
import 'package:mpax_flutter/utils/debug.dart';
import 'package:path/path.dart' as path;

class AudioList extends ConsumerStatefulWidget {
  const AudioList(this.playlistName, {this.loadStep = 20, super.key});

  final String playlistName;

  final int loadStep;

  @override
  ConsumerState<AudioList> createState() => _AudioListState();
}

class _AudioListState extends ConsumerState<AudioList> {
  final _scrollController = ScrollController();
  final _refreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  List<int> musicIdList = <int>[];
  List<Music> musicList = <Music>[];

  @override
  void initState() {
    super.initState();
    if (musicIdList.isEmpty) {
      final playlist = ref
          .read(databaseProvider.notifier)
          .findPlaylistByNameSync(widget.playlistName);
      if (playlist != null) {
        musicIdList = playlist.musicList;
      }
      debug('>>>> length: ${musicIdList.length}');
    }
  }

  int _count = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void clearData() {
    _count = 0;
  }

  Future<void> loadData() async {
    int loadCount = 0;
    while (musicIdList.length > _count + loadCount &&
        loadCount < widget.loadStep) {
      final music = await ref
          .read(databaseProvider.notifier)
          .findMusicById(musicIdList[_count + loadCount]);
      if (music != null) {
        musicList.add(music);
      }
      loadCount++;
    }
    setState(() {
      _count += loadCount;
    });
  }

  @override
  Widget build(BuildContext context) => EasyRefresh(
        controller: _refreshController,
        scrollController: _scrollController,
        refreshOnStart: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _count,
          itemExtent: 65,
          itemBuilder: (context, index) {
            debug('>>>> build list $index ${musicList[index].fileName}');
            return AudioItem(musicList[index]);
          },
        ),
        onRefresh: () async {
          clearData();
          await loadData();
          _refreshController
            ..finishRefresh()
            ..resetFooter();
        },
        onLoad: () async {
          await loadData();
          _refreshController.finishLoad();
        },
      );
}

class AudioItem extends ConsumerWidget {
  const AudioItem(this.music, {super.key});

  final Music music;

  Future<String?> _fetchArtwork(WidgetRef ref) async {
    final artworkId = music.firstArtwork();
    if (artworkId == null) {
      return null;
    }
    final artworkData =
        await ref.read(databaseProvider.notifier).findArtworkById(artworkId);
    if (artworkData == null) {
      return null;
    }
    return artworkData.data;
  }

  Future<String> _fetchArtist(WidgetRef ref) async {
    final artistIdList = music.artistList;
    final artistString = await ref
        .read(databaseProvider.notifier)
        .findArtistNamesByIdList(artistIdList);
    return artistString;
  }

  Future<String> _fetchAlbum(WidgetRef ref) async {
    final albumId = music.album;
    return ref.read(databaseProvider.notifier).findAlbumTitleById(albumId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const spaceBox = SizedBox(
      width: 50,
      height: 50,
      child: Icon(Icons.music_note),
    );

    return ListTile(
      leading: FutureBuilder(
        future: _fetchArtwork(ref),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return spaceBox;
          } else if (snapshot.connectionState != ConnectionState.done) {
            return spaceBox;
          } else {
            final artwork = snapshot.data;
            if (artwork == null) {
              return spaceBox;
            }
            return ListTileLeading(
              child: Image.memory(
                base64Decode(artwork),
                width: 50,
                height: 50,
                isAntiAlias: true,
              ),
            );
          }
        },
      ),
      title: Text(
        music.title ?? path.basename(music.filePath),
        maxLines: 1,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
            future: _fetchArtist(ref),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('');
              } else if (snapshot.connectionState != ConnectionState.done) {
                return const Text('');
              } else {
                final artistString = snapshot.data;
                return Text(
                  artistString!,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                );
              }
            },
          ),
          if (true)
            FutureBuilder(
              future: _fetchAlbum(ref),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('');
                } else if (snapshot.connectionState != ConnectionState.done) {
                  return const Text('');
                } else {
                  final albumString = snapshot.data;
                  return Text(
                    albumString!,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  );
                }
              },
            )
        ],
      ),
      trailing: IconButton(
        onPressed: () async {
          // TODO: Menu
        },
        icon: const Icon(Icons.more_horiz),
      ),
      onTap: () async {
        final title = music.title ?? path.basename(music.filePath);
        final artist = await _fetchArtist(ref);
        final album = await _fetchAlbum(ref);
        final artworkRaw = await _fetchArtwork(ref);
        final Uint8List artwork;
        if (artworkRaw == null) {
          artwork = Uint8List(0);
        } else {
          artwork = base64Decode(artworkRaw);
        }
        await ref.read(playerProvider).play(
              music.filePath,
              title: title,
              artist: artist,
              album: album,
              artwork: artwork,
            );
      },
      isThreeLine: true,
      titleAlignment: ListTileTitleAlignment.top,
    );
  }
}

/// Center placed item for [ListTile].
class ListTileLeading extends StatelessWidget {
  /// Constructor.
  const ListTileLeading({required this.child, super.key});

  /// Widget tot show.
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [child],
      );
}