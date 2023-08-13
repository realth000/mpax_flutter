import 'dart:io';
import 'dart:typed_data';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/player_provider.dart';
import 'package:mpax_flutter/provider/playlist_provider.dart';
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
  int playlistId = -1;

  @override
  void initState() {
    super.initState();
    if (musicIdList.isEmpty) {
      final playlist = ref
          .read(databaseProvider.notifier)
          .findPlaylistByNameSync(widget.playlistName);
      if (playlist != null) {
        musicIdList = playlist.musicList;
        playlistId = playlist.id;
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
    musicList.clear();
    _count = 0;
  }

  Future<bool> loadData() async {
    var loadCount = 0;
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
    if (loadCount == 0) {
      return false;
    }
    setState(() {
      _count += loadCount;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) => EasyRefresh(
        header: const MaterialHeader(),
        footer: const MaterialFooter(),
        controller: _refreshController,
        scrollController: _scrollController,
        refreshOnStart: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _count,
          itemExtent: 65,
          itemBuilder: (context, index) {
            debug('>>>> build list $index ${musicList[index].fileName}');
            return AudioItem(musicList[index], playlistId);
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
          final allLoaded = await loadData();
          _refreshController.finishLoad(
            allLoaded ? IndicatorResult.noMore : IndicatorResult.success,
          );
        },
      );
}

class AudioItem extends ConsumerWidget {
  const AudioItem(this.music, this.playlistId, {super.key});

  final Music music;
  final int playlistId;

  Future<Uint8List?> _fetchArtwork(WidgetRef ref) async {
    final artworkId = music.firstArtwork();
    if (artworkId == null) {
      return null;
    }
    final artworkData =
        await ref.read(databaseProvider.notifier).findArtworkById(artworkId);
    if (artworkData == null) {
      return null;
    }
    final file = File(artworkData.filePath);
    if (!file.existsSync()) {
      await ref
          .read(databaseProvider.notifier)
          .reloadArtwork(music.filePath, artworkId);
    }
    return file.readAsBytes();
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
    return FutureBuilder(
      future: Future.wait(
          [_fetchArtwork(ref), _fetchArtist(ref), _fetchAlbum(ref)]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AudioPlaceholder(message: snapshot.error.toString());
        } else if (snapshot.connectionState != ConnectionState.done ||
            snapshot.data == null) {
          return const AudioPlaceholder();
        } else {
          final artwork = snapshot.data![0];
          final artist = snapshot.data![1];
          final album = snapshot.data![2];

          return ListTile(
            leading: ListTileLeading(
              child: artwork == null
                  ? const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.music_note),
                    )
                  : Image.memory(
                      artwork as Uint8List,
                      width: 50,
                      height: 50,
                      isAntiAlias: true,
                    ),
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
                if (artist == null)
                  const Text('')
                else
                  Text(
                    artist as String,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                if (album == null)
                  const Text('')
                else
                  Text(
                    album as String,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
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
              final title = music.title ?? path.basename(music.filePath);
              final artist = await _fetchArtist(ref);
              final album = await _fetchAlbum(ref);
              final artwork = await _fetchArtwork(ref);
              await ref.read(playerProvider).play(
                    music.id,
                    music.filePath,
                    title: title,
                    artist: artist,
                    album: album,
                    artwork: artwork,
                    artworkId: music.firstArtwork(),
                    playlistId: playlistId,
                  );
              if (playlistId > 0) {
                await ref.read(playlistProvider).setPlaylistById(playlistId);
              }
            },
            isThreeLine: true,
            titleAlignment: ListTileTitleAlignment.top,
          );
        }
      },
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

class AudioPlaceholder extends StatelessWidget {
  const AudioPlaceholder({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const SizedBox(
          width: 50,
          height: 50,
          child: Icon(Icons.music_note),
        ),
        title: Text(message ?? ''),
      );
}
