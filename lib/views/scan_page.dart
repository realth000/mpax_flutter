import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/metadata_service.dart';
import 'package:mpax_flutter/utils/scan_target_controller.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:path/path.dart' as path;

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: 'Scan music'.tr,
      ),
      bottomNavigationBar: const MPaxPlayerWidget(),
      drawer: const MPaxDrawer(),
      body: _ScanBodyWidget(),
    );
  }
}

class _ScanBodyWidget extends StatelessWidget {
  final controller = Get.put(_ScanController());

  Widget _buildControlCard() {
    return Card(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Obx(() => Checkbox(
                    value: controller.searchSkipRecorded.value,
                    onChanged: (value) async {
                      if (value == null) {
                        return;
                      }
                      controller.searchSkipRecorded.value = value;
                      await Get.find<ConfigService>()
                          .saveBool('ScanSkipRecordedFile', value);
                    },
                  )),
              Text('Skip recorded music files'.tr),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.start),
            title: Text('Start scan'.tr),
            onTap: () async {
              await controller.scanTargetList();
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text('Add directory to scan'.tr),
            onTap: () async {
              final d = await FilePicker.platform.getDirectoryPath();
              if (d == null) {
                return;
              }
              controller.add(d);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          _buildControlCard(),
          Expanded(
            child: Scrollbar(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.length(),
                  itemExtent: 70,
                  itemBuilder: (context, index) {
                    return controller.widgetAt(index);
                    // return Text('$index');
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanController extends GetxController {
  _ScanController() {
    final targets = Get.find<ConfigService>().getStringList('ScanTargetList');
    if (targets == null) {
      return;
    }
    for (var target in targets) {
      _scanList[target] = _ScanTargetItemWidget(target);
    }
    searchSkipRecorded.value =
        Get.find<ConfigService>().getBool('ScanSkipRecordedFile') ?? false;
  }

  final searchSkipRecorded = false.obs;

  ConfigService configService = Get.find<ConfigService>();
  final _scanList = <String, _ScanTargetItemWidget>{}.obs;
  MediaLibraryService libraryService = Get.find<MediaLibraryService>();

  int length() {
    return _scanList.values.length;
  }

  String nameAt(int index) {
    return _scanList.value.keys.elementAt(index);
  }

  Widget widgetAt(int index) {
    return _scanList.value.values.elementAt(index);
  }

  void add(String path) {
    if (_scanList.containsKey(path)) {
      return;
    }
    _scanList[path] = _ScanTargetItemWidget(path);
    update();
    configService.saveStringList('ScanTargetList', _scanList.keys.toList());
  }

  void delete(String path) {
    _scanList.remove(path);
    update();
    configService.saveStringList('ScanTargetList', _scanList.keys.toList());
  }

  Future<void> scanTargetList() async {
    if (Get.find<ConfigService>().getBool('ScanSkipRecordedFile') == false) {
      libraryService.resetLibrary();
    }
    await Future.forEach(_scanList.entries, (entry) async {
      await entry.value.controller.startScan(AudioScanOptions.fromConfig());
    });
    await libraryService.saveAllPlaylist();
  }
}

enum ScanTargetStatus {
  invalid,
  ready,
  scanning,
  finished,
}

class _ScanTargetItemController extends GetxController {
  final _metadataService = Get.find<MetadataService>();
  final _deleteIcon = const Icon(Icons.delete).obs;

  String target = '';
  ScanTargetStatus _status = ScanTargetStatus.ready;
  final mediaLibraryService = Get.find<MediaLibraryService>();

  void setStatus(ScanTargetStatus status) {
    _status = status;
    buildTailIcon();
    update();
  }

  void buildTailIcon() {
    switch (_status) {
      case ScanTargetStatus.ready:
        _deleteIcon.value = const Icon(Icons.delete);
        break;
      case ScanTargetStatus.scanning:
        _deleteIcon.value = const Icon(Icons.refresh);
        break;
      case ScanTargetStatus.finished:
      case ScanTargetStatus.invalid:
        _deleteIcon.value = const Icon(Icons.delete);
        break;
    }
  }

  Future<void> startScan(AudioScanOptions options) async {
    if (target.isEmpty) {
      setStatus(ScanTargetStatus.ready);
      update();
      return;
    }
    setStatus(ScanTargetStatus.scanning);
    await Future.delayed(const Duration(milliseconds: 200));
    final d = Directory(target);
    // FileSystemEntity.isFileSync(entry.toString())
    for (final entry in d.listSync(recursive: true, followLinks: false)) {
      final scanner = AudioScanner(targetPath: entry.path, options: options);
      await scanner.scan();
    }
    setStatus(ScanTargetStatus.ready);
    update();
  }

  Future<void> scan(String targetPath) async {
    if (targetPath.isEmpty) {
      return;
    }
    final d = Directory(targetPath);
    // FileSystemEntity.isFileSync(entry.toString())
    await for (final entry in d.list(recursive: true, followLinks: false)) {
      if (entry.statSync().type == FileSystemEntityType.file) {
        if (!entry.path.endsWith('mp3')) {
          continue;
        }
        // Add to list
        mediaLibraryService
            .addContent(await _metadataService.readMetadata(entry.path));
      } else if (entry.statSync().type == FileSystemEntityType.directory) {
        scan(entry.path);
      }
    }
  }
}

class _ScanTargetItemWidget extends StatelessWidget {
  _ScanTargetItemWidget(this.targetPath);

  final String targetPath;

  final controller = _ScanTargetItemController();

  @override
  ListTile build(BuildContext context) {
    controller.target = targetPath;
    return ListTile(
      horizontalTitleGap: 2.0,
      title: Text(path.split(targetPath).last),
      subtitle: Text(targetPath),
      leading: const Icon(Icons.folder),
      trailing: IconButton(
        icon: Obx(() => controller._deleteIcon.value),
        onPressed: () {
          if (controller._status == ScanTargetStatus.scanning) {
            return;
          }
          Get.find<_ScanController>().delete(controller.target);
        },
      ),
    );
  }
}
