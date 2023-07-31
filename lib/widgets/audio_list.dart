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
    final playlist = ref
        .read(databaseProvider.notifier)
        .findPlaylistByNameSync(widget.playlistName);
    if (playlist != null) {
      musicIdList = playlist.musicList;
    }
    debug('>>>> ${musicIdList.length}');
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
    while (musicIdList.length > _count && loadCount < widget.loadStep) {
      debug('>>>> load $_count');
      final music = await ref
          .read(databaseProvider.notifier)
          .findMusicById(musicIdList[_count]);
      if (music != null) {
        musicList.add(music);
      }
      loadCount++;
      _count++;
    }
  }

  @override
  Widget build(BuildContext context) => EasyRefresh(
        controller: _refreshController,
        scrollController: _scrollController,
        refreshOnStart: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _count,
          itemExtent: 30,
          itemBuilder: (context, index) {
            debug('>>>> build list $index ${musicList[index].fileName}');
            return Text(musicList[index].fileName);
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
