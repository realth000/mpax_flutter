import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/mobile/components/mobile_underfoot.dart';
import 'package:mpax_flutter/services/locale_service.dart';
import 'package:mpax_flutter/services/media_library_service.dart';
import 'package:mpax_flutter/services/settings_service.dart';
import 'package:mpax_flutter/services/theme_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';
import 'package:window_manager/window_manager.dart';

/// Action types for [
enum _MusicFolderMenuActions {
  openFolder,
  copyPath,
  delete,
}

/// Auto theme mode icon.
const autoModeIcon = Icon(Icons.auto_mode);

/// Light theme mode icon.
const lightModeIcon = Icon(Icons.light_mode);

/// Dark theme mode icon.
const darkModeIcon = Icon(Icons.dark_mode);

/// Settings page in drawer.
class SettingsPage extends StatelessWidget {
  /// Constructor.
  const SettingsPage({super.key});

  /// TODO: Migrate to desktop.
  _SettingsBodyWidget get body => _SettingsBodyWidget();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MPaxAppBar(
          title: 'Settings'.tr,
        ),
        drawer: const MPaxDrawer(),
        body: _SettingsBodyWidget(),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const MPaxPlayerWidget(),
            if (GetPlatform.isMobile) const MobileUnderfoot(),
          ],
        ),
      );
}

class _ThemeGroup {
  _ThemeGroup({required this.themeMode, required this.name});

  final MPaxThemeMode themeMode;
  final String name;
}

class _SettingsBodyWidget extends GetView<SettingsService> {
  _SettingsBodyWidget();

  final _themeService = Get.find<ThemeService>();
  final _localeService = Get.find<LocaleService>();

  final _scrollController = ScrollController();
  final _targetScrollController = ScrollController();

  final _musicDirectoryList =
      (Get.find<SettingsService>().getStringList('ScanTargetList') ??
              <String>[])
          .obs;

  // /// Current using theme icon.
  // final _themeIcon = autoModeIcon.obs;

  final List<Icon> _themeIcons = <Icon>[
    lightModeIcon,
    autoModeIcon,
    darkModeIcon,
  ];
  final _themeList = <_ThemeGroup>[
    _ThemeGroup(themeMode: MPaxThemeMode.light, name: lightModeString),
    _ThemeGroup(themeMode: MPaxThemeMode.auto, name: autoModeString),
    _ThemeGroup(themeMode: MPaxThemeMode.dark, name: darkModeString),
  ];
  final _selections = List.generate(3, (_) => false).obs;

  Future<void> _openLocaleMenu() async {
    final locale = await Get.dialog<String>(_LocaleMenu());
    await _localeService.changeLocale(locale);
  }

  Widget _buildMusicFoldersCard(BuildContext context) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
              ),
              child: TitleText(
                title: 'Media libraries'.tr,
                level: 0,
              ),
            ),
            ListTile(
              leading: const ListTileLeading(
                child: Icon(Icons.my_library_music),
              ),
              title: Text('Music Folders'.tr),
              trailing: TextButton.icon(
                icon: const Icon(Icons.add),
                label: Text('Add'.tr),
                onPressed: () async {
                  final directory =
                      await FilePicker.platform.getDirectoryPath();
                  if (directory == null ||
                      _musicDirectoryList.contains(directory)) {
                    return;
                  }
                  _musicDirectoryList
                    ..add(directory)
                    ..refresh();
                  await controller.saveStringList(
                    'ScanTargetList',
                    _musicDirectoryList,
                  );
                  await Get.find<MediaLibraryService>()
                      .addMusicFolder(directory);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: Obx(
                () => SingleChildScrollView(
                  controller: _targetScrollController,
                  child: ListView.builder(
                    controller: _targetScrollController,
                    itemCount: _musicDirectoryList.length,
                    itemExtent: 45,
                    itemBuilder: (context, index) => ListTile(
                      leading: const ListTileLeading(
                        child: Icon(Icons.folder),
                      ),
                      title: Text(
                        _musicDirectoryList[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) =>
                            <PopupMenuItem<_MusicFolderMenuActions>>[
                          PopupMenuItem(
                            value: _MusicFolderMenuActions.openFolder,
                            child: Row(
                              children: [
                                const Icon(Icons.folder_open),
                                Text('Open folder'.tr),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _MusicFolderMenuActions.copyPath,
                            child: Row(
                              children: [
                                const Icon(Icons.copy),
                                Text('Copy path'.tr),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: _MusicFolderMenuActions.delete,
                            child: Row(
                              children: [
                                const Icon(Icons.delete),
                                Text('Delete'.tr),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) async {
                          switch (value) {
                            case _MusicFolderMenuActions.openFolder:
                              return;
                            case _MusicFolderMenuActions.copyPath:
                              await Clipboard.setData(
                                ClipboardData(
                                  text: _musicDirectoryList[index],
                                ),
                              );
                              return;
                            case _MusicFolderMenuActions.delete:
                              await Get.find<MediaLibraryService>()
                                  .removeMusicFolder(
                                _musicDirectoryList[index],
                              );
                              _musicDirectoryList.removeAt(index);
                              await controller.saveStringList(
                                'ScanTargetList',
                                _musicDirectoryList,
                              );
                              return;
                          }
                        },
                      ),
                    ),
                    shrinkWrap: true,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Widget _buildAppearanceCard(BuildContext context) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                top: 10,
              ),
              child: TitleText(
                title: 'Appearance'.tr,
                level: 0,
              ),
            ),
            _buildThemeWidget(context),
            ListTile(
              leading: const ListTileLeading(
                child: Icon(Icons.language),
              ),
              title: Text('Language'.tr),
              subtitle: Text('Set application language'.tr),
              trailing: Obx(() => Text(_localeService.locale.value.tr)),
              onTap: () async => _openLocaleMenu(),
            ),
            if (GetPlatform.isMobile) _buildMobileAppBottomWidget(),
            if (GetPlatform.isDesktop)
              _buildDesktopUseNativeTitleBarWidget(context),
          ],
        ),
      );

  Widget _buildThemeWidget(BuildContext context) => Obx(
        () => ListTile(
          leading: const ListTileLeading(
            child: Icon(Icons.invert_colors),
            // child: Icon(Icons.theme),
          ),
          title: Text('Theme'.tr),
          subtitle: Text(_themeService.themeModeString.value.tr),
          trailing: ToggleButtons(
            onPressed: (index) async {
              if (_selections[index]) {
                return;
              }
              for (var i = 0; i < _selections.length; i++) {
                _selections[i] = false;
              }
              _selections[index] = true;
              await _themeService.changeThemeMode(_themeList[index].themeMode);
            },
            isSelected: _selections,
            children: _themeIcons,
          ),
        ),
      );

  Widget _buildMobileAppBottomWidget() => ListTile(
        leading: const ListTileLeading(
          child: Icon(Icons.height),
        ),
        title: Text('App Bottom Height'.tr),
        subtitle: Text('Avoid hovered by navigation bar'.tr),
        trailing: PopupMenuButton<double>(
          child: Obx(
            () => Text(
              controller.appBottomHeight.value.toInt().toString(),
            ),
          ),
          itemBuilder: (context) => const <PopupMenuItem<double>>[
            PopupMenuItem(
              value: 10,
              child: Text('10'),
            ),
            PopupMenuItem(
              value: 20,
              child: Text('20'),
            ),
            PopupMenuItem(
              value: 40,
              child: Text('40'),
            ),
            PopupMenuItem(
              value: 50,
              child: Text('50'),
            ),
            PopupMenuItem(
              value: 60,
              child: Text('60'),
            ),
            PopupMenuItem(
              value: 70,
              child: Text('70'),
            ),
          ],
          onSelected: (value) async {
            controller.appBottomHeight.value = value;
            await controller.saveDouble(
              'AppBottomUnderfootHeight',
              value,
            );
          },
        ),
      );

  Widget _buildDesktopUseNativeTitleBarWidget(BuildContext context) => ListTile(
        leading: const Icon(Icons.padding),
        title: Text('Native title bar'.tr),
        subtitle: Text('Use system native title bar'.tr),
        trailing: Obx(
          () => Switch(
            value: controller.desktopUseNativeTittleBar.value,
            onChanged: (value) async {
              if (value) {
                await windowManager.setTitleBarStyle(TitleBarStyle.normal);
              } else {
                await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
                await windowManager.setAsFrameless();
              }
              await controller.saveBool('UseSystemNativeTitleBar', value);
              controller.desktopUseNativeTittleBar.value = value;
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_themeService.followSystemDarkMode) {
      _selections[1] = true;
    } else if (_themeService.useDarkTheme) {
      _selections[2] = true;
    } else {
      _selections[0] = true;
    }

    final widgetList = <Widget>[];

    widgetList.add(_buildMusicFoldersCard(context));

    // Always show appearance card.
    widgetList.add(_buildAppearanceCard(context));

    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgetList,
          ),
        ),
      ),
    );
  }
}

class _LocaleMenu extends StatelessWidget {
  final List<Widget> _localeList = <Widget>[];

  List<Widget> _buildLocaleList() {
    _localeList
      ..clear()
      ..add(
        ListTile(
          title: Text(LocaleService.autoLocale.tr),
          onTap: () {
            Get.back(result: LocaleService.autoLocale);
          },
        ),
      );

    // for (final locale in localMap.keys) {
    //   _localeList.add(
    //     ListTile(
    //       title: Text(
    //         locale.tr,
    //       ),
    //       onTap: () => Get.back(result: locale),
    //     ),
    //   );
    // }
    return _localeList;
  }

  @override
  Widget build(BuildContext context) => ModalDialog(
        child: Column(
          children: _buildLocaleList(),
        ),
      );
}
