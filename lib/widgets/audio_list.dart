import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

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

  List<int> musicIdFullList = <int>[];
  List<int> musicIdList = <int>[];
  int playlistId = -1;

  Future<void> loadListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await loadData();
    }
  }

  @override
  void initState() {
    super.initState();
    if (musicIdFullList.isEmpty) {
      final playlist = ref
          .read(databaseProvider)
          .findPlaylistByNameSync(widget.playlistName);
      if (playlist != null) {
        musicIdFullList = playlist.musicList;
        playlistId = playlist.id;
      }
    }
    // FIXME: Decide first load size to ensure loaded data can fill the whole list
    // Or use something else to trigger loading more data.
    //
    // Here load 40 items at first load to cover most situation.
    loadData(loadSize: 40);
    _scrollController.addListener(loadListener);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(loadListener)
      ..dispose();
    super.dispose();
  }

  void clearData() {
    musicIdList.clear();
  }

  Future<bool> loadData({int? loadSize}) async {
    if (musicIdList.length >= musicIdFullList.length) {
      return false;
    }
    musicIdList.addAll(musicIdFullList.getRange(
        musicIdList.length,
        min(musicIdList.length + (loadSize ?? widget.loadStep),
            musicIdFullList.length)));
    return true;
  }

  @override
  Widget build(BuildContext context) => Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: musicIdList.length,
          itemExtent: 65,
          cacheExtent: 5,
          itemBuilder: (context, index) {
            debug('>>>> build list $index');
            final music = ref
                .read(databaseProvider)
                .fetchMusicByIdSync(musicIdList[index]);
            if (music == null) {
              return Text('Music id ${musicIdList[index]} not found');
            }
            return AudioItem(music, playlistId);
          },
        ),
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
        await ref.read(databaseProvider).findArtworkById(artworkId);
    if (artworkData == null) {
      return null;
    }
    final file = File(artworkData.filePath);
    if (!file.existsSync()) {
      await ref.read(databaseProvider).reloadArtwork(music.filePath, artworkId);
    }
    return file.readAsBytes();
  }

  Future<String> _fetchArtist(WidgetRef ref) async {
    final artistIdList = music.artistList;
    final artistString =
        await ref.read(databaseProvider).findArtistNamesByIdList(artistIdList);
    return artistString;
  }

  Future<String> _fetchAlbum(WidgetRef ref) async {
    final albumId = music.album;
    return ref.read(databaseProvider).findAlbumTitleById(albumId);
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
