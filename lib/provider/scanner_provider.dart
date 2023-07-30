import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mpax_flutter/models/metadata_model.dart';
import 'package:mpax_flutter/provider/app_state_provider.dart';
import 'package:mpax_flutter/provider/settings_provider.dart';
import 'package:mpax_flutter/utils/debug.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scanner_provider.freezed.dart';
part 'scanner_provider.g.dart';

@freezed
class ScanOptions with _$ScanOptions {
  const factory ScanOptions({
    required List<String> allowedExtensions,
  }) = _ScanOptions;
}

@riverpod
class Scanner extends _$Scanner {
  @override
  ScanOptions build() {
    return const ScanOptions(
      allowedExtensions: <String>['.mp3', '.flac', '.m4a'],
    );
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
      await Metadata(entity.path).fetch();
    }
    return <String>[];
  }
}
