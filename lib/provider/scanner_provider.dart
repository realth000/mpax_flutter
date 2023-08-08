import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mpax_flutter/models/artist_model.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/database_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/utils/compress.dart';
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

  Future<List<String>> scan() async {
    if (ref.read(appStateProvider).isScanning) {
      debug('already scanning, exit');
      return <String>[];
    }
    debug('start scan');
    ref.read(appStateProvider.notifier).setScanning(true);
    return _scanMusic();
  }

  Future<List<String>> _scanMusic() async {
    final targets = ref.read(appSettingsProvider).scanDirectoryList;
    final ret = <String>[];
    for (final directory in targets) {
      debug('scanning $directory');
      ret.addAll(await _scanDir(directory));
    }
    debug('finish scan');
    ref.read(appStateProvider.notifier).setScanning(false);
    return ret;
  }

  Future<List<String>> _scanDir(String directory) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      debug('scan dir not exists: ${dir.path}');
      return <String>[];
    }

    final allowedExtensions = state.allowedExtensions;
    final loadImage = state.loadImage;
    final scaleImage = state.scaleImage;

    final db = ref.read(databaseProvider.notifier);

    final futures = <Future<Metadata?>>[];

    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is! File) {
        debug('scan skip not a file: ${entity.path}');
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
      futures.add(fetchMetadata(entity.path));
    }

    debug('>>> futures count: ${futures.length}');

    final metadataList = await Future.wait<Metadata?>(futures);

    for (final metadata in metadataList) {
      if (metadata == null) {
        continue;
      }

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
          final data = await compressImage(metadata.artworkUnknown!);
          final artwork = await db.fetchArtwork(ArtworkFormat.jpeg, data);
          music.artworkUnknown = artwork.id;
        } else {
          final artwork = await db.fetchArtwork(
            ArtworkFormat.jpeg,
            metadata.artworkUnknown!,
            scaleImage: scaleImage,
          );
          music.artworkUnknown = artwork.id;
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
}
