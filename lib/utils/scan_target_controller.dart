import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

import '../models/music_model.dart';
import '../models/playlist_model.dart';
import '../services/media_library_service.dart';
import '../services/metadata_service.dart';
import '../services/settings_service.dart';

/// Option used in scanning audio files.
class AudioScanOptions {
  /// Construct form raw options.
  AudioScanOptions.raw({required this.searchAll, required this.loadImage});

  /// Construct from app config.
  AudioScanOptions.fromConfig() {
    final configService = Get.find<SettingsService>();
    searchAll = configService.getBool('ScanSkipRecordedFile') ?? false;
    loadImage = configService.getBool('ScanLoadImage') ?? true;
  }

  /// Update some part.
  AudioScanOptions copyWith({bool? searchAll, bool? loadImage}) =>
      AudioScanOptions.raw(
        searchAll: searchAll ?? this.searchAll,
        loadImage: loadImage ?? this.loadImage,
      );

  /// If false, skip already included audio files (those were scanned before).
  bool searchAll = false;

  /// Load cover image or not.
  bool loadImage = false;
}

/// Scanner for audio.
///
/// Scan on disk, filter file types and fetch metadata.
class AudioScanner {
  /// Constructor.
  AudioScanner({required this.targetPath, this.targetModel, this.options});

  final _mediaLibraryService = Get.find<MediaLibraryService>();
  final _metadataService = Get.find<MetadataService>();

  final _scanStreamController = StreamController<String>(sync: true);

  /// Scanning stream, provide current scanning file path.
  late final Stream<String> scanStream = _scanStreamController.stream;
  late final _scanStreamSink = _scanStreamController.sink;

  /// Scan start path, go into that directory.
  final String targetPath;

  /// Save all scanned audio content in this [PlaylistModel] and
  /// [_mediaLibraryService].
  /// Can be null which means only save in library.
  PlaylistModel? targetModel;

  /// Options use in scanning.
  AudioScanOptions? options;

  var _scannedCount = 0;

  /// Start scan.
  Future<int> scan() async {
    _scannedCount = 0;
    final scannedAudioList = <Music>[];
    late final Directory d;
    if (targetPath.isNotEmpty) {
      d = Directory(targetPath);
    }

    await _scan(d, scannedAudioList);
    _mediaLibraryService.addContentList(scannedAudioList);
    if (targetModel != null) {
      targetModel!.addMusicList(scannedAudioList);
    }
    _scannedCount += scannedAudioList.length;
    scannedAudioList.clear();
    // await _scanStreamSink.close();
    return _scannedCount;
  }

  Future<void> _scan(FileSystemEntity entry, List<Music> list) async {
    /*

    switch (entry.statSync().type) {
      case FileSystemEntityType.file:
        if (entry.path.endsWith('mp3')) {
          _scanStreamSink.add(entry.path);
          list.add(
            await _metadataService.readMetadata(
              entry.path,
              loadImage: options?.loadImage ?? true,
            ),
          );
        }

        /// Short return list to reduce memory use.
        if (list.length >= 200) {
          _mediaLibraryService.addContentList(list);
          if (targetModel != null) {
            targetModel!.addMusicList(list);
          }
          await _mediaLibraryService.saveAllPlaylist();
          _scannedCount += list.length;
          list.clear();
        }
        break;
      case FileSystemEntityType.directory:
        await for (final entry
            in (entry as Directory).list(recursive: true, followLinks: false)) {
          if (entry.statSync().type == FileSystemEntityType.file) {
            if (!entry.path.endsWith('mp3')) {
              continue;
            }
            // Add to list.
            _scanStreamSink.add(entry.path);
            list.add(
              await _metadataService.readMetadata(
                entry.path,
                loadImage: options?.loadImage ?? true,
              ),
            );

            /// Short return list to reduce memory use.
            if (list.length >= 10) {
              _mediaLibraryService.addContentList(list);
              if (targetModel != null) {
                targetModel!.addMusicList(list);
              }
              _scannedCount += list.length;
              list.clear();
            }
          } else if (entry.statSync().type == FileSystemEntityType.directory) {
            await _scan(entry, list);
          }
        }
        break;
    }
  }
     */
  }
}
