import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(title: "Scan music".tr,),
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
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: Text('Add directory'.tr),
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
      builder: (_scanController c){
        return c.buildScanTarget();
      },
    );
  }
}

class _scanController extends GetxController {
  // TODO: Make this not null!!
  Rx<List<String>?> scanList = Get.find<ConfigService>().getStringList(
      'ScanTargetList').obs;
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

  Widget buildScanTarget(){
    List<ListTile> w = <ListTile>[];
    if (scanList.value == null) {
      return Column(children: []);
    }
    for (var path in scanList.value!) {
      w.add(buildScanTargetItem(path));
    }
    return Column(children: w,);
  }
}
