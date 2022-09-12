import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/audio_library_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

import '../models/play_content.model.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: "Scan music".tr,
      ),
      drawer: const MPaxDrawer(),
      body: _scanBodyWidget(),
    );
  }
}

class _scanBodyWidget extends StatelessWidget {
  _scanBodyWidget({super.key});

  final _targetListWidget = _scanTargetList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.start),
          title: Text('Start scan'.tr),
          onTap: () async {
            _scanDirectories d= _scanDirectories();
            d.scanTargetList();
          },
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text('Add directory to scan'.tr),
          onTap: () async {
            String? d = await FilePicker.platform.getDirectoryPath();
            if (d == null) {
              return;
            }
            // TODO: Show in list, save in config and write to config file.
            Get.find<_scanController>().add(d);
          },
        ),
        _targetListWidget,
      ],
    );
  }
}

class _scanTargetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<_scanController>(
      init: _scanController(),
      builder: (_scanController c) {
        return c.buildScanTarget();
      },
    );
  }
}

class _scanController extends GetxController {
  // TODO: Make this not null!!
  Rx<List<String>?> scanList =
      Get.find<ConfigService>().getStringList('ScanTargetList').obs;
  ConfigService configService = Get.find<ConfigService>();

  void add(String path) {
    scanList.value ??= <String>[];
    if (scanList.value!.contains(path)) {
      return;
    }
    scanList.value!.add(path);
    update();
    configService.saveStringList('ScanTargetList', scanList.value!);
  }

  void delete(String path) {
    scanList.value ??= <String>[];
    scanList.value!.remove(path);
    update();
    configService.saveStringList('ScanTargetList', scanList.value!);
  }

  ListTile buildScanTargetItem(String dirPath) {
    return ListTile(
      title: Text(path.split(dirPath).last),
      subtitle: Text(dirPath),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => {delete(dirPath)},
      ),
    );
  }

  Widget buildScanTarget() {
    List<ListTile> w = <ListTile>[];
    if (scanList.value == null) {
      return Column(children: []);
    }
    for (var path in scanList.value!) {
      w.add(buildScanTargetItem(path));
    }
    return Column(
      children: w,
    );
  }
}

class _scanDirectories {
  final List<String> _scanList =
      Get.find<ConfigService>().getStringList('ScanTargetList') ?? <String>[];
  AudioLibraryService audioLibraryService = Get.find<AudioLibraryService>();

  void scanTargetList() async {
    print('!! Start scan!!${_scanList}');
    for (var e in _scanList) {
      await _scan(e);
    }
  }

  Future<void> _scan(String targetPath) async {
    if (targetPath.isEmpty) {
      return;
    }
    final Directory d = Directory(targetPath);
    // FileSystemEntity.isFileSync(entry.toString())
    await for (FileSystemEntity entry
        in d.list(recursive: true, followLinks: false)) {
      if (entry.statSync().type == FileSystemEntityType.file) {
        if (!entry.path.endsWith('mp3')) {
          continue;
        }
        // Add to list
        audioLibraryService.addContent(PlayContent.fromEntry(entry));
      } else if (entry.statSync().type == FileSystemEntityType.directory) {
        _scan(entry.path);
      }
    }
  }
}
