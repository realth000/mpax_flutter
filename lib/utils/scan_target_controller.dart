import 'dart:io';

import 'package:get/get.dart';
import 'package:mpax_flutter/models/play_content.model.dart';
import 'package:mpax_flutter/models/playlist.model.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';

class AudioScanner {
  AudioScanner({required this.targetPath, this.targetModel});

  final mediaLibraryService = Get.find<MediaLibraryService>();
  final _metadataService = Get.find<MetadataService>();

  final String targetPath;
  PlaylistModel? targetModel;

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
    return scannedAudioList.length;
  }

  Future<void> _scan(FileSystemEntity entry, List<PlayContent> list) async {
    switch (entry.statSync().type) {
      case FileSystemEntityType.file:
        if (entry.path.endsWith('mp3')) {
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
