import 'dart:convert';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/utils/debug.dart';

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
          itemExtent: 60,
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

  Future<String?> _leadingIcon(WidgetRef ref) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const spaceBox = SizedBox(
      width: 56,
      height: 56,
      child: Icon(Icons.music_note),
    );
    return ListTile(
      leading: FutureBuilder(
        future: _leadingIcon(ref),
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
            return Image.memory(
              base64Decode(artwork),
              width: 56,
              height: 56,
              isAntiAlias: true,
            );
          }
        },
      ),
      title: const Text(
        '',
        // playContent.title.isEmpty
        //     ? path.basename(playContent.filePath)
        //     : playContent.title,
        maxLines: 2,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      subtitle: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '',
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            '',
            // playContent.albumTitle.isEmpty
            //     ? playContent.filePath
            //         .replaceFirst('/storage/emulated/0/', '')
            //     : playContent.albumTitle,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: () async {
          // TODO: Menu
        },
        icon: const Icon(Icons.more_horiz),
      ),
      onTap: () async {
        // TODO: Play.
      },
      // This important.
      isThreeLine: true,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [child],
      );
}
