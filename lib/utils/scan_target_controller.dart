import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';

class AudioScanOptions {
  AudioScanOptions.raw({required this.searchAll});

  AudioScanOptions.fromConfig() {
    final configService = Get.find<ConfigService>();
    searchAll = configService.getBool('ScanSkipRecordedFile') ?? false;
  }

  AudioScanOptions copyWith({bool? searchAll}) {
    return AudioScanOptions.raw(
      searchAll: searchAll ?? this.searchAll,
    );
  }

  bool searchAll = false;
}

class AudioScanner {
  AudioScanner({required this.targetPath, this.targetModel, this.options});

  final mediaLibraryService = Get.find<MediaLibraryService>();
  final _metadataService = Get.find<MetadataService>();

  final _scanStreamController = StreamController<String>(sync: true);
  late final Stream<String> scanStream = _scanStreamController.stream;
  late final _scanStreamSink = _scanStreamController.sink;

  final String targetPath;
  PlaylistModel? targetModel;
  AudioScanOptions? options;

  Future<int> scan() async {
    List<PlayContent> scannedAudioList = <PlayContent>[];
    late final Directory d;
    if (targetPath.isNotEmpty) {
      d = Directory(targetPath);
    }

    await _scan(d, scannedAudioList);
    mediaLibraryService.addContentList(scannedAudioList);
    if (targetModel != null) {
      targetModel!.addContentList(scannedAudioList);
    }
    _scanStreamSink.close();
    return scannedAudioList.length;
  }

  Future<void> _scan(FileSystemEntity entry, List<PlayContent> list) async {
    switch (entry.statSync().type) {
      case FileSystemEntityType.file:
        if (entry.path.endsWith('mp3')) {
          _scanStreamSink.add(entry.path);
          list.add(
              await _metadataService.readMetadata(entry.path, loadImage: true));
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
            list.add(await _metadataService.readMetadata(entry.path,
                loadImage: true));
          } else if (entry.statSync().type == FileSystemEntityType.directory) {
            _scan(entry, list);
          }
        }
        break;
      default:
        break;
    }
  }
}
