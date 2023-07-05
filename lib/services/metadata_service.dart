import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:isolate_manager/isolate_manager.dart';
import 'package:metadata_god/metadata_god.dart' as mg;
import 'package:mpax_flutter/models/album_model.dart';
import 'package:mpax_flutter/models/artist_model.dart';
import 'package:mpax_flutter/models/artwork_model.dart';
import 'package:mpax_flutter/models/artwork_with_type_model.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/models/music_model.dart';
import 'package:mpax_flutter/models/playlist_model.dart';
import 'package:mpax_flutter/services/database_service.dart';
import 'package:path/path.dart' as path;
import 'package:taglib_ffi/taglib_ffi.dart' as tl;

/// Read metadata in isolates
@pragma('vm:entry-point')
FutureOr<List> _readMetadataParallelWrapper(dynamic path) async =>
    <dynamic>[path, await MetadataService._readMetadata(path as String)];

/// Manage audio metadata, globally.
class MetadataService extends GetxService {
  final _storage = Get.find<DatabaseService>().storage;

  /// Return a [Music].
  ///
  /// If exists a music with [filePath], return it.
  /// Otherwise make a new [Music].
  Future<Music> fetchMusic(
    String filePath, {
    Metadata? metadata,
  }) async {
    final storedMusic =
        await _storage.musics.where().filePathEqualTo(filePath).findFirst();
    if (storedMusic != null) {
      return storedMusic;
    }
    final music = Music.fromPath(filePath);
    await _storage.writeTxn(() async => _storage.musics.put(music));
    await music.refreshMetadata(metadata: metadata);
    return music;
  }

  /// Return a [Artist].
  ///
  /// If exists an artist with [name], return it.
  /// Otherwise make a new [Artist].
  Future<Artist> fetchArtist(
    String name,
  ) async {
    final storedArtist =
        await _storage.artists.where().nameEqualTo(name).findFirst();
    if (storedArtist != null) {
      return storedArtist;
    }
    final artist = Artist(name: name);
    await _storage.writeTxn(() async => _storage.artists.put(artist));
    return artist;
  }

  /// Return a [Album].
  ///
  /// If exists an album with [title] and [artists], return it.
  /// Otherwise make a new [Album].
  Future<Album> fetchAlbum(
    String title,
    List<Id> artists, {
    String? albumTitle,
    int? albumTrackCount,
    Map<ArtworkType, Artwork>? artworkList,
  }) async {
    final a = await _storage.albums.where().titleEqualTo(title).findFirst();
    if (a != null) {
      return a;
    }
    final album = Album(title: title, artistIds: artists);
    await _storage.writeTxn(() async => _storage.albums.put(album));
    return album;
  }

  /// Return a [Artwork].
  ///
  /// If exists an artwork with [Artwork.dataHash] equals to hashed [data],
  /// return it.
  /// Otherwise make a new [Artwork].
  Future<Artwork> fetchArtwork(ArtworkFormat format, String data) async {
    final a = await _storage.artworks
        .where()
        .dataHashEqualTo(Artwork.calculateDataHash(data))
        .findFirst();
    if (a != null) {
      return a;
    }
    final artwork = Artwork(format: format, data: data);
    await _storage.writeTxn(() async => _storage.artworks.put(artwork));
    return artwork;
  }

  /// Return a [ArtworkWithType]
  ///
  /// If exists one with given [artworkType] and [artwork], return it.
  /// Otherwise make a new [ArtworkWithType].
  Future<ArtworkWithType> fetchArtworkWithType(
    ArtworkType artworkType,
    Artwork artwork,
  ) async {
    final awt = await _storage.artworkWithTypes
        .filter()
        .typeEqualTo(artworkType)
        .and()
        .artworkEqualTo(artwork.id)
        .findFirst();
    if (awt != null) {
      return awt;
    }
    final a = await fetchArtwork(artwork.format, artwork.data);
    final artworkWithType = ArtworkWithType(a.id, artworkType);
    await _storage
        .writeTxn(() async => _storage.artworkWithTypes.put(artworkWithType));
    await artworkWithType.save();
    return artworkWithType;
  }

  /// Return a list of [Playlist]. Returning a list because playlist allowed to
  /// have same name.
  ///
  /// Return all playlist has the given [playlistName].
  /// If not exists, return a new one.
  Future<List<Playlist>> fetchPlaylist(
    String playlistName,
  ) async {
    final p =
        await _storage.playlists.where().nameEqualTo(playlistName).findAll();
    if (p.isNotEmpty) {
      return p;
    }
    final playlist = Playlist()..name = playlistName;
    await _storage.writeTxn(() async => _storage.playlists.put(playlist));
    return [playlist];
  }

  /// Get a [Music] filled with metadata read from given [filePath].
  Future<Metadata?> readMetadata(
    String filePath, {
    bool loadImage = false,
    bool scaleImage = true,
    bool fast = true,
  }) async =>
      _readMetadata(filePath,
          loadImage: loadImage, scaleImage: scaleImage, fast: fast);

  /// Get a [Music] filled with metadata read from given [filePath].
  ///
  /// Make as a static wrapper function, because we want to use this in
  /// another isolate and class member functions can not sent between isolates.
  static Future<Metadata?> _readMetadata(
    String filePath, {
    bool loadImage = false,
    bool scaleImage = true,
    bool fast = true,
  }) async {
    final s = File(filePath).statSync();
    if (s.type != FileSystemEntityType.file) {
      if (kDebugMode) {
        print(' file is not file type, return null');
      }
      return null;
    }

    // Because metadata_god can load image and handles both utf8 and latin1
    // strings, use it on Windows and when need load cover images.
    // Because taglib_ffi can load sample rate, bitrate and ..., but can
    // not handle latin1 parameters, only use in utf8 environment and not need
    // cover images.
    if (fast) {
      late final mg.Metadata? metadata;
      try {
        metadata = await mg.MetadataGod.readMetadata(file: filePath);
        if (metadata == null) {
          if (kDebugMode) {
            print('metadata god return null');
          }
          return null;
        }
        return _applyMetadataFromMG(
          filePath,
          metadata,
          loadImage,
          scaleImage,
        );
      } catch (e) {
        // May have ffi exception.
        // Can not read metadata, maybe from m4a files.
        //   Only write basic info.
        //   TODO: Should print something here.
        if (kDebugMode) {
          print('metadatagod exception $e');
        }
        return null;
      }
    } else {
      late final tl.Metadata? metadata;
      late final Music music;
      try {
        metadata = await tl.TagLib(filePath: filePath).readMetadataEx();
        if (metadata == null) {
          if (kDebugMode) {
            print('taglib_ffi return null');
          }
          return null;
        }
        return await _applyMetadataFromTL(
          filePath,
          metadata,
          loadImage,
          scaleImage,
        );
      } catch (e) {
        //   TODO: Do something here.
        if (kDebugMode) {
          print('AAAA error: $e');
        }
        return null;
      }
    }
  }

  /// Fetch metadata with package metadata_god.
  static Future<Metadata?> _applyMetadataFromMG(
    String filePath,
    mg.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final ret = Metadata(filePath)
      ..artist = metadata.artist
      ..title = metadata.title
      ..track = metadata.trackNumber
      ..albumTrackCount = metadata.trackTotal
      ..albumTitle = metadata.album
      ..albumYear = metadata.year;
    if (metadata.albumArtist != null) {
      ret.albumArtist = <String>[metadata.albumArtist!];
    }
    if (metadata.genre != null && metadata.genre != ' ') {
      ret.genre = metadata.genre;
    }
    if (metadata.picture == null || !loadImage) {
      return ret;
    }

    ret.artworkMap ??= <ArtworkType, Artwork>{};
    if (scaleImage && GetPlatform.isMobile) {
      final tmpList = await FlutterImageCompress.compressWithList(
        metadata.picture!.data,
        minWidth: 120,
        minHeight: 120,
      );
      ret.artworkMap![ArtworkType.unknown] = Artwork(
        format: metadata.picture!.mimeType.contains('png')
            ? ArtworkFormat.png
            : ArtworkFormat.jpeg,
        data: base64Encode(tmpList),
      );
    } else if (!scaleImage) {
      ret.artworkMap![ArtworkType.unknown] = Artwork(
        format: metadata.picture!.mimeType.contains('png')
            ? ArtworkFormat.png
            : ArtworkFormat.jpeg,
        data: base64Encode(metadata.picture!.data),
      );
    }
    return ret;
  }

  /// Fetch metadata with package taglib_ffi.
  static Future<Metadata?> _applyMetadataFromTL(
    String filePath,
    tl.Metadata metadata,
    bool loadImage,
    bool scaleImage,
  ) async {
    final ret = Metadata(filePath)
      ..artist = metadata.artist
      ..title = metadata.title
      ..track = metadata.track
      ..albumTrackCount = metadata.albumTotalTrack
      ..albumTitle = metadata.album
      ..albumYear = metadata.year
      ..bitrate = metadata.bitrate
      ..sampleRate = metadata.sampleRate
      ..channels = metadata.channels
      ..length = metadata.length
      ..lyrics = metadata.lyrics
      ..comment = metadata.comment;
//    if (metadata.albumArtist != null) {
//      playContent.albumArtist = metadata.albumArtist!;
//    }
    // FIXME: Seems some files have a genre value ' ',
    // is blank but contains a space.
    // Do not know is id3 tag standard or file corruption or mis-edit,
    // just filter this situation now.
    if (metadata.albumArtist != null) {
      ret.albumArtist = <String>[metadata.albumArtist!];
    }
    if (metadata.genre != null && metadata.genre != ' ') {
      ret.genre = metadata.genre;
    }

    if (metadata.albumCover != null && loadImage) {
      ret.artworkMap ??= <ArtworkType, Artwork>{};
      if (scaleImage && GetPlatform.isMobile) {
        final tmpList = await FlutterImageCompress.compressWithList(
          metadata.albumCover!,
          minWidth: 120,
          minHeight: 120,
        );
        ret.artworkMap![ArtworkType.unknown] = Artwork(
          /// FIXME: Add artwork format here.
          format: ArtworkFormat.jpeg,
          data: base64Encode(tmpList),
        );
      } else if (!scaleImage) {
        ret.artworkMap![ArtworkType.unknown] = Artwork(
          /// FIXME: Add artwork format here.
          format: ArtworkFormat.jpeg,
          data: base64Encode(metadata.albumCover!),
        );
      }
    }

    return ret;
  }

  /// Load lyrics with given content.
  ///
  /// Load priority:
  /// 1. Lyrics in [music].
  /// 2. Lyrics in [music] file: reload lyrics from file.
  /// 3. Same name "*.lrc" file in same folder.
  /// 4. "<Artist> - <Title>.lrc" file in same folder.
  /// 5. User selected file.
  ///
  /// When [forceReload] is true, skip step 1.
  /// When [loadFilePath] is not null, only run step 5.
  Future<String?> loadLyrics(
    Music music, {
    bool? forceReload,
    String? loadFilePath,
  }) async {
    late String lyricsFilePath;
    late File lyricsFile;
    if (loadFilePath != null) {
      /// 5. User selected file.
      lyricsFile = File(loadFilePath);
      return lyricsFile.existsSync() ? await lyricsFile.readAsString() : '';
    }
    // 1. Lyrics in [content].
    if (music.lyrics != null &&
        music.lyrics!.isNotEmpty &&
        forceReload != null &&
        !forceReload) {
      return music.lyrics;
    }
    // 2. Lyrics in [content] file: reload lyrics from file.
    final metadata = await readMetadata(music.filePath);
    if (metadata != null &&
        metadata.lyrics != null &&
        metadata.lyrics!.isNotEmpty) {
      return metadata.lyrics;
    }
    final ext = path.extension(music.filePath);
    // 3. Same name "*.lrc" file in same folder.
    lyricsFilePath = ext.isEmpty
        ? '${music.filePath}.lrc'
        : music.filePath.replaceAll(path.extension(music.filePath), '.lrc');
    lyricsFile = File(lyricsFilePath);
    if (lyricsFile.existsSync()) {
      final s = await lyricsFile.readAsString();
      if (s.isNotEmpty) {
        return s;
      }
    }

    /// 4. "<Artist> - <Title>.lrc" file in same folder.
    if (music.title != null && music.title!.isNotEmpty) {
      lyricsFilePath = music.artistList.isEmpty
          ? '${path.dirname(music.filePath)}/${music.title}.lrc'
          // FIXME: Fix lyric file path with artist name.
          : '${path.dirname(music.filePath)}/${music.artistList.join()} - ${music.title}.lrc';
      lyricsFile = File(lyricsFilePath);
      if (lyricsFile.existsSync()) {
        final s = await lyricsFile.readAsString();
        if (s.isNotEmpty) {
          return s;
        }
      }
    }
    return '';
  }

  /// Read metadata parallel.
  Future<List<Metadata>> readMetadataParallel(
    List<String> pathList, {
    int concurrent = 8,
  }) async {
    final ret = <Metadata>[];

    final isolateManager = IsolateManager<List<dynamic>>.create(
      _readMetadataParallelWrapper,
      concurrent: concurrent,
    );

    await isolateManager.start();
    isolateManager.stream.listen((List<dynamic> result) {
      if (result[1] == null) {
        return;
      }
      ret.add(result[1] as Metadata);
    });
    for (final p in pathList) {
      await isolateManager.compute(p);
    }
    await isolateManager.stop();

    return ret;
  }

  /// Init function, run before app start.
  Future<MetadataService> init() async => this;
}
