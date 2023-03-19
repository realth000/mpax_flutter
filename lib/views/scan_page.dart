import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import '../mobile/components/mobile_underfoot.dart';
import '../services/media_library_service.dart';
import '../services/metadata_service.dart';
import '../services/settings_service.dart';
import '../utils/scan_target_controller.dart';
import '../widgets/app_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_player_widget.dart';

/// Scan audio content page in drawer.
class ScanPage extends StatelessWidget {
  /// Constructor.
  const ScanPage({super.key});

  /// TODO: Migrate to desktop.
  get body => _ScanBodyWidget();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: 'Scan music'.tr,
        ),
        drawer: const MPaxDrawer(),
        body: _ScanBodyWidget(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
      );
}

class _ScanBodyWidget extends StatelessWidget {
  final _controller = Get.put(_ScanController());

  Widget _buildControlCard() => Card(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Obx(
                  () => Checkbox(
                    value: _controller.searchSkipRecorded.value,
                    onChanged: (value) async {
                      if (value == null) {
                        return;
                      }
                      _controller.searchSkipRecorded.value = value;
                      await Get.find<SettingsService>()
                          .saveBool('ScanSkipRecordedFile', value);
                    },
                  ),
                ),
                Text('Skip recorded music files'.tr),
              ],
            ),
            // Row(
            //   children: <Widget>[
            //     Obx(
            //       () => Checkbox(
            //         value: _controller.loadImage.value,
            //         onChanged: (value) async {
            //           if (value == null) {
            //             return;
            //           }
            //           _controller.loadImage.value = value;
            //           await Get.find<ConfigService>()
            //               .saveBool('ScanLoadImage', value);
            //         },
            //       ),
            //     ),
            //     Text('Load image in audio metadata tags'.tr),
            //   ],
            // ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text('Add directory to scan'.tr),
              onTap: () async {
                final d = await FilePicker.platform.getDirectoryPath();
                if (d == null) {
                  return;
                }
                await _controller.add(d);
              },
            ),
            ListTile(
              leading: const Icon(Icons.start),
              title: Text('Start scan'.tr),
              onTap: () async {
                await _controller.scanTargetList();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            _buildControlCard(),
            Expanded(
              child: Scrollbar(
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.length(),
                    itemExtent: 70,
                    itemBuilder: (context, index) =>
                        _controller.widgetAt(index),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _ScanController extends GetxController {
  _ScanController() {
    final targets = Get.find<SettingsService>().getStringList('ScanTargetList');
    if (targets == null) {
      return;
    }
    for (final target in targets) {
      _scanList[target] = _ScanTargetItemWidget(target);
    }
    searchSkipRecorded.value =
        Get.find<SettingsService>().getBool('ScanSkipRecordedFile') ?? false;
    loadImage
      ..value = Get.find<SettingsService>().getBool('ScanLoadImage') ?? true
      // Temporarily always enable load image.
      ..value = true;
  }

  final searchSkipRecorded = false.obs;
  final loadImage = true.obs;

  SettingsService configService = Get.find<SettingsService>();
  final _scanList = <String, _ScanTargetItemWidget>{}.obs;
  MediaLibraryService libraryService = Get.find<MediaLibraryService>();

  int length() => _scanList.values.length;

  String nameAt(int index) => _scanList.keys.elementAt(index);

  Widget widgetAt(int index) => _scanList.values.elementAt(index);

  Future<void> add(String path) async {
    if (_scanList.containsKey(path)) {
      return;
    }
    _scanList[path] = _ScanTargetItemWidget(path);
    update();
    await configService.saveStringList(
      'ScanTargetList',
      _scanList.keys.toList(),
    );
  }

  Future<void> delete(String path) async {
    _scanList.remove(path);
    update();
    await configService.saveStringList(
      'ScanTargetList',
      _scanList.keys.toList(),
    );
  }

  Future<void> scanTargetList() async {
    if (Get.find<SettingsService>().getBool('ScanSkipRecordedFile') == false) {
      libraryService.resetLibrary();
    }
    await Future.forEach(_scanList.entries, (entry) async {
      await entry.value._controller.startScan(AudioScanOptions.fromConfig());
    });
    await libraryService.saveAllPlaylist();
  }
}

/// Scanning status for scan item.
enum ScanTargetStatus {
  /// Not used.
  invalid,

  /// Ready to scan.
  ready,

  /// Scanning this item.
  scanning,

  /// Scan finished.
  finished,
}

class _ScanTargetItemController extends GetxController {
  final _metadataService = Get.find<MetadataService>();
  final _deleteIcon = const Icon(Icons.delete).obs;

  String target = '';
  ScanTargetStatus _status = ScanTargetStatus.ready;
  final mediaLibraryService = Get.find<MediaLibraryService>();
  final currentTarget = ''.obs;

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
    final scanner = AudioScanner(targetPath: target, options: options);
    scanner.scanStream.listen((event) {
      currentTarget.value = event;
    });
    final scannedCount = await scanner.scan();
    setStatus(ScanTargetStatus.ready);
    currentTarget.value = '${'Scanned'.tr} $scannedCount';
    update();
  }

//  Future<void> scan(String targetPath) async {
//    if (targetPath.isEmpty) {
//      return;
//    }
//    final d = Directory(targetPath);
//    // FileSystemEntity.isFileSync(entry.toString())
//    await for (final entry in d.list(recursive: true, followLinks: false)) {
//      if (entry.statSync().type == FileSystemEntityType.file) {
//        if (!entry.path.endsWith('mp3')) {
//          continue;
//        }
//        // Add to list
//        mediaLibraryService
//            .addContent(await _metadataService.readMetadata(entry.path));
//      } else if (entry.statSync().type == FileSystemEntityType.directory) {
//        await scan(entry.path);
//      }
//    }
//  }
}

class _ScanTargetItemWidget extends StatelessWidget {
  _ScanTargetItemWidget(this._targetPath);

  final String _targetPath;

  final _controller = _ScanTargetItemController();

  @override
  ListTile build(BuildContext context) {
    _controller.target = _targetPath;
    return ListTile(
      horizontalTitleGap: 2,
      title: Text(path.split(_targetPath).last),
      subtitle: Obx(
        () => Text(
          _controller.currentTarget.value
              .replaceFirst('/storage/emulated/0/', ''),
        ),
      ),
      leading: const Icon(Icons.folder),
      trailing: IconButton(
        icon: Obx(() => _controller._deleteIcon.value),
        onPressed: () async {
          if (_controller._status == ScanTargetStatus.scanning) {
            return;
          }
          await Get.find<_ScanController>().delete(_controller.target);
        },
      ),
    );
  }
}
