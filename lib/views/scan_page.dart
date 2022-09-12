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
      body: _ScanBodyWidget(),
    );
  }
}

class _ScanBodyWidget extends StatelessWidget {
  final _targetListWidget = _ScanTargetListWidget();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.start),
          title: Text('Start scan'.tr),
          onTap: () async {
            _ScanController c = Get.find<_ScanController>();
            c.scanTargetList();
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
            Get.find<_ScanController>().add(d);
          },
        ),
        _targetListWidget,
      ],
    );
  }
}

class _ScanTargetListWidget extends StatelessWidget {
  // _ScanTargetListWidget(){Get.put(() => _ScanController());}
  // // Not work?
  // final _ScanController _scanController = Get.find<_ScanController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_ScanController>(
      init: _ScanController(),
      builder: (_ScanController c) {
        return c.buildScanTarget();
      },
    );
  }
}

class _ScanController extends GetxController {
  // TODO: Make this not null!!
  Rx<List<String>?> scanList =
      Get.find<ConfigService>().getStringList('ScanTargetList').obs;
  ConfigService configService = Get.find<ConfigService>();

  List<_ScanTargetItemWidget> targetItemList = <_ScanTargetItemWidget>[];

  // Future<void> setScanningState() async {
  //   for (var element in targetItemList) {
  //     element.controller.setStatus(ScanTargetStatus.scanning);
  //   }
  // }

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
    for (var element in targetItemList) {
      if (element.targetPath == path) {
        targetItemList.remove(element);
        break;
      }
    }
    update();
    configService.saveStringList('ScanTargetList', scanList.value!);
  }

  void scanTargetList() async {
    print("!!! START: length=${targetItemList.length}");
    for (var element in targetItemList) {
      await element.controller.startScan();
    }
  }

  // Build UI Widget.
  Widget buildScanTarget() {
    List<ListTile> s = <ListTile>[];
    if (scanList.value == null) {
      return Column(children: const []);
    }
    targetItemList.clear();
    for (var path in scanList.value!) {
      targetItemList.add(buildScanTargetItem(path) as _ScanTargetItemWidget);
      s.add(targetItemList.last);
    }
    return Column(
      children: s,
    );
  }

  ListTile buildScanTargetItem(String dirPath) {
    return _ScanTargetItemWidget(dirPath);
  }
}

enum ScanTargetStatus {
  invalid,
  ready,
  scanning,
  finished,
}

class _ScanTargetItemController extends GetxController {
  var deleteIcon = Icon(Icons.delete).obs;

  String target = "";
  ScanTargetStatus _status = ScanTargetStatus.ready;
  final AudioLibraryService audioLibraryService =
      Get.find<AudioLibraryService>();

  void setStatus(ScanTargetStatus status) {
    _status = status;
    buildTailIcon();
    update();
  }

  void buildTailIcon() {
    switch (_status) {
      case ScanTargetStatus.ready:
        deleteIcon.value = const Icon(Icons.delete);
        break;
      case ScanTargetStatus.scanning:
        deleteIcon.value = const Icon(Icons.refresh);
        break;
      case ScanTargetStatus.finished:
        deleteIcon.value =  const Icon(Icons.delete);
        break;
      default:
        deleteIcon.value = const Icon(Icons.question_mark);
    }
  }

  Future<void> startScan() async {
    if (target.isEmpty) {
      setStatus(ScanTargetStatus.ready);
      update();
      return;
    }
    setStatus(ScanTargetStatus.scanning);
    print("Start scan: $target, ${deleteIcon.value.icon}");
    await Future.delayed(const Duration(seconds: 1));
    final Directory d = Directory(target);
    // FileSystemEntity.isFileSync(entry.toString())
    for (FileSystemEntity entry
        in d.listSync(recursive: true, followLinks: false)) {
      if (entry.statSync().type == FileSystemEntityType.file) {
        if (!entry.path.endsWith('mp3')) {
          continue;
        }
        // Add to list
        audioLibraryService.addContent(PlayContent.fromEntry(entry));
      } else if (entry.statSync().type == FileSystemEntityType.directory) {
        scan(entry.path);
      }
    }
    setStatus(ScanTargetStatus.ready);
    update();
    print("Finish scan: $target");
  }

  Future<void> scan(String targetPath) async {
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
        scan(entry.path);
      }
    }
  }
}

class _ScanTargetItemWidget extends ListTile {

  _ScanTargetItemWidget(this.targetPath){
    controller = _ScanTargetItemController();
  }

  late final _ScanTargetItemController controller;


  final String targetPath;

  @override
  ListTile build(BuildContext context) {
    controller.target = targetPath;
    return ListTile(
      horizontalTitleGap: 2.0,
      title: Text(path.split(targetPath).last),
      subtitle: Text(targetPath),
      leading: const Icon(Icons.folder),
      trailing: IconButton(
        icon: Obx(() => controller.deleteIcon.value),
        onPressed: () {
          if (controller._status == ScanTargetStatus.scanning) {
            return;
          }
          _ScanController c = Get.find<_ScanController>();
          c.delete(controller.target);
        },
      ),
    );
  }
}
