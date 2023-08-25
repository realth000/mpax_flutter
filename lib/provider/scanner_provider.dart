import 'dart:core';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:metadata_god/metadata_god.dart' as metadata_god;
import 'package:mpax_flutter/models/artist_model.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/utils/debug.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:taglib_ffi/taglib_ffi.dart' as taglib;

part 'scanner_provider.freezed.dart';
part 'scanner_provider.g.dart';

@freezed
class ScanOptions with _$ScanOptions {
  const factory ScanOptions({
    required List<String> allowedExtensions,
    required bool loadImage,
    required bool scaleImage,
  }) = _ScanOptions;
}

@riverpod
class Scanner extends _$Scanner {
  @override
  ScanOptions build() {
    return const ScanOptions(
      allowedExtensions: <String>['.mp3', '.flac', '.m4a'],
      loadImage: false,
      scaleImage: true,
    );
  }

  void setLoadImage(bool loadImage) {
    state = state.copyWith(loadImage: loadImage);
  }

  void setScaleImage(bool scaleImage) {
    state = state.copyWith(scaleImage: scaleImage);
  }

  void addAllowedExtension(String extension) {
    final extensionList = state.allowedExtensions.toList()..add(extension);
    state = state.copyWith(allowedExtensions: extensionList);
  }

  Future<List<String>> scan({
    int? playlistId,
    List<String>? paths,
  }) async {
    assert((playlistId == null && paths == null) ||
        (playlistId != null && paths != null));

    if (ref.read(appStateProvider).isScanning) {
      debug('already scanning, exit');
      return <String>[];
    }

    if (paths != null) {
      await ref.read(appSettingsProvider.notifier).addScanDirectories(paths);
    }

    debug('start scan');
    ref.read(appStateProvider.notifier).setScanning(true);
    return _scanMusic(
      playlistId: playlistId,
      overridePaths: paths,
    );
  }

  Future<List<String>> _scanMusic(
      {int? playlistId, List<String>? overridePaths}) async {
    final targets =
        overridePaths ?? ref.read(appSettingsProvider).scanDirectoryList;
    final ret = <String>[];

    final Playlist? targetPlaylist;
    if (playlistId != null) {
      targetPlaylist =
          await ref.read(databaseProvider).fetchPlaylistById(playlistId);
      if (targetPlaylist == null) {
        // This should not happen
        debug('error: try to scan for a playlist that not exists');
        return [];
      }
    } else {
      targetPlaylist = null;
    }

    for (final directory in targets) {
      debug('scanning $directory');
      ret.addAll(await _scanDir(directory, playlist: targetPlaylist));
    }
    debug('finish scan');
    ref.read(appStateProvider.notifier).setScanning(false);
    return ret;
  }

  Future<List<String>> _scanDir(String directory, {Playlist? playlist}) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      debug('scan dir not exists: ${dir.path}');
      return <String>[];
    }

    final allowedExtensions = state.allowedExtensions;
    final loadImage = state.loadImage;
    final scaleImage = state.scaleImage;

    final db = ref.read(databaseProvider);

    final futures = <Future<metadata_god.Metadata?>>[];
    final pathList = <String>[];
    final metadataList = <Metadata>[];

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is Directory) {
        debug('!!! check subdirectory: ${entity.path}');
        final result = await _scanDir(entity.path, playlist: playlist);
        continue;
      }

      if (!allowedExtensions.contains(path.extension(entity.path))) {
        debug('scan skip not a audio file: ${entity.path}');
        continue;
      }

      debug('reading metadata: ${entity.path}');
      // final metadata = await fetchMetadata(entity.path);
      // if (metadata == null) {
      //   continue;
      // }
      debug('check: ${entity.path}');
      futures.add(fetchMetadataGodMetadata(entity.path));
      pathList.add(entity.path);
    }

    debug('futures count: ${futures.length}');

    debug('start generating metadata');

    // (await Future.wait<taglib.Metadata?>(futures))
    //     .forEachIndexed((index, taglibMetadata) {
    //   if (taglibMetadata == null) {
    //     return;
    //   }
    //
    //   final ret = Metadata(pathList[index]);
    //
    //   debug('get metadata: ${taglibMetadata.title}, ${taglibMetadata.artist}');
    //   ret
    //     ..title = taglibMetadata.title
    //     ..artist = taglibMetadata.artist
    //     ..albumTitle = taglibMetadata.album;
    //   if (taglibMetadata.albumArtist != null) {
    //     ret.albumArtist
    //       ..clear()
    //       ..add(taglibMetadata.albumArtist!);
    //   }
    //   ret
    //     ..track = taglibMetadata.track
    //     ..albumTrackCount = taglibMetadata.albumTotalTrack
    //     ..albumYear = taglibMetadata.year
    //     ..genre = taglibMetadata.genre
    //     ..comment = taglibMetadata.comment
    //     ..sampleRate = taglibMetadata.sampleRate
    //     ..bitrate = taglibMetadata.bitrate
    //     ..channels = taglibMetadata.channels
    //     ..length = taglibMetadata.length
    //     ..lyrics = taglibMetadata.lyrics
    //     ..artworkUnknown = taglibMetadata.albumCover;
    //   metadataList.add(ret);
    // });

    (await Future.wait<metadata_god.Metadata?>(futures))
        .forEachIndexed((index, metadata) {
      if (metadata == null) {
        return;
      }

      final ret = Metadata(pathList[index]);
      debug('get metadata: ${metadata.title}, ${metadata.artist}');
      ret
        ..title = metadata.title
        ..artist = metadata.artist
        ..albumTitle = metadata.album;

      if (metadata.albumArtist != null) {
        ret.albumArtist
          ..clear()
          ..add(metadata.albumArtist!);
      }

      ret
        ..track = metadata.trackNumber
        ..albumTrackCount = metadata.trackTotal
        ..albumYear = metadata.year
        ..genre = metadata.genre
        ..comment = null
        ..sampleRate = null
        ..bitrate = null
        ..channels = null
        ..length = metadata.duration?.inSeconds
        ..lyrics = null;

      if (metadata.picture != null) {
        ret.artworkUnknown = metadata.picture!.data;
      }
      metadataList.add(ret);
    });

    // Use to record cover image id of playlist.
    // This should me the first image scanned in music metadata.
    // Do nothing if playlist is null.
    var playlistCoverId = -1;

    for (final metadata in metadataList) {
      // Save models.
      final music = await db.fetchMusic(metadata.filePath);
      music
        ..fileName = path.basename(music.filePath)
        ..fileSize = File(music.filePath).lengthSync()
        ..title = metadata.title
        ..trackNumber = metadata.track
        ..bitRate = metadata.bitrate
        ..sampleRate = metadata.sampleRate
        ..channels = metadata.channels
        ..genre = metadata.genre
        ..length = metadata.length
        ..lyrics = metadata.lyrics
        ..comment = metadata.comment;

      // Save [Artist].
      Artist? _artist;
      if (metadata.artist != null) {
        final artist = await db.fetchArtist(metadata.artist!);
        music.artistList.add(artist.id);
        _artist = artist;
      }

      // Save [Artwork].
      // TODO: Save all cover images.
      if (loadImage && metadata.artworkUnknown != null) {
        if (scaleImage) {
          final artwork = await db.fetchArtwork(
            ArtworkFormat.jpeg,
            metadata.artworkUnknown!,
          );
          music.artworkUnknown = artwork.id;
        } else {
          final artwork = await db.fetchArtwork(
            ArtworkFormat.jpeg,
            metadata.artworkUnknown!,
            scaleImage: scaleImage,
          );
          music.artworkUnknown = artwork.id;
        }

        if (playlist != null && playlistCoverId < 0) {
          playlistCoverId = music.artworkUnknown ?? -1;
        }
      }

      // Save [Album].
      if (metadata.albumTitle != null) {
        final albumArtistList = <int>[];
        for (final aa in metadata.albumArtist) {
          final artist = await db.fetchArtist(aa);
          albumArtistList.add(artist.id);
        }
        final album = await db.fetchAlbum(
          metadata.albumTitle!,
          albumArtistList,
          albumTitle: metadata.albumTitle,
          albumTrackCount: metadata.albumTrackCount,
          albumYear: metadata.albumYear,
          artworkId: music.artworkUnknown,
        );
        music.album = album.id;
      }

      await db.saveMusic(music);
      if (_artist != null) {
        await _artist.addMusic(music);
        await db.saveArtist(_artist);
      }

      if (playlist != null) {
        playlist = playlist.makeGrowable();
        await playlist.addMusic(music);
      }
    }

    if (playlist != null) {
      playlist.coverArtworkId = playlistCoverId > 0 ? playlistCoverId : null;
      await db.savePlaylist(playlist);
    }

    return <String>[];
  }

  Future<Metadata?> fetchMetadata(String filePath) async {
    final Metadata ret = Metadata(filePath);
    final taglibMetadata = await taglib.readMetadata(filePath);
    if (taglibMetadata == null) {
      return null;
    }
    debug('get metadata: ${taglibMetadata.title}, ${taglibMetadata.artist}');
    ret
      ..title = taglibMetadata.title
      ..artist = taglibMetadata.artist
      ..albumTitle = taglibMetadata.album;
    if (taglibMetadata.albumArtist != null) {
      ret.albumArtist
        ..clear()
        ..add(taglibMetadata.albumArtist!);
    }
    ret
      ..track = taglibMetadata.track
      ..albumTrackCount = taglibMetadata.albumTotalTrack
      ..albumYear = taglibMetadata.year
      ..genre = taglibMetadata.genre
      ..comment = taglibMetadata.comment
      ..sampleRate = taglibMetadata.sampleRate
      ..bitrate = taglibMetadata.bitrate
      ..channels = taglibMetadata.channels
      ..length = taglibMetadata.length
      ..lyrics = taglibMetadata.lyrics
      ..artworkUnknown = taglibMetadata.albumCover;
    return ret;
  }

  Future<taglib.Metadata?> fetchTagLibMetadata(String filePath) async {
    return taglib.readMetadata(filePath);
  }

  Future<metadata_god.Metadata?> fetchMetadataGodMetadata(
      String filePath) async {
    return metadata_god.MetadataGod.readMetadata(file: filePath);
  }
}
