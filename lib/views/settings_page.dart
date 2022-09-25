import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';
import 'package:mpax_flutter/services/locale_service.dart';
import 'package:mpax_flutter/services/theme_service.dart';
import 'package:mpax_flutter/widgets/app_app_bar.dart';
import 'package:mpax_flutter/widgets/app_drawer.dart';
import 'package:mpax_flutter/widgets/app_player_widget.dart';
import 'package:mpax_flutter/widgets/util_widgets.dart';

const autoModeIcon = Icon(Icons.auto_mode);
const lightModeIcon = Icon(Icons.light_mode);
const darkModeIcon = Icon(Icons.dark_mode);
final autoModeString = 'Follow system'.tr;
final lightModeString = 'Light mode'.tr;
final darkModeString = 'Dark mode'.tr;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MPaxAppBar(
        title: 'Settings'.tr,
      ),
      bottomNavigationBar: const MPaxPlayerWidget(),
      drawer: const MPaxDrawer(),
      body: _SettingsBodyWidget(),
    );
  }
}

class _SettingsBodyWidget extends GetView<ConfigService> {
  final _themeService = Get.find<ThemeService>();
  final _localeService = Get.find<LocaleService>();

  final themeName = autoModeString.obs;
  final themeIcon = autoModeIcon.obs;

  Future<void> _openThemeMenu() async {
    final theme = await Get.dialog(_ThemeMenu());
    switch (theme) {
      case MPaxThemeMode.light:
        themeIcon.value = lightModeIcon;
        themeName.value = lightModeString;
        _themeService.changeThemeMode(MPaxThemeMode.light);
        break;
      case MPaxThemeMode.dark:
        themeIcon.value = darkModeIcon;
        themeName.value = darkModeString;
        _themeService.changeThemeMode(MPaxThemeMode.dark);
        break;
      case MPaxThemeMode.auto:
        themeIcon.value = autoModeIcon;
        themeName.value = autoModeString;
        _themeService.changeThemeMode(MPaxThemeMode.auto);
    }
  }

  Future<void> _openLocaleMenu() async {
    final locale = await Get.dialog(_LocaleMenu());
    await _localeService.changeLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    if (_themeService.followSystemDarkMode) {
      themeIcon.value = autoModeIcon;
      themeName.value = autoModeString;
    } else if (_themeService.useDarkTheme) {
      themeIcon.value = darkModeIcon;
      themeName.value = darkModeString;
    } else {
      themeIcon.value = lightModeIcon;
      themeName.value = lightModeString;
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TitleText(
                title: 'Appearance'.tr,
                level: 0,
              ),
              ListTile(
                leading: ListTileLeading(
                  child: Obx(() => themeIcon.value),
                ),
                title: Text('Theme'.tr),
                subtitle: Text('Follow system/Light/Dark'.tr),
                trailing: Obx(() => Text(themeName.value.tr)),
                onTap: () async => await _openThemeMenu(),
              ),
              ListTile(
                leading: const ListTileLeading(
                  child: Icon(Icons.language),
                ),
                title: Text('Language'.tr),
                subtitle: Text('Set application language'.tr),
                trailing: Obx(() => Text(_localeService.locale.value.tr)),
                onTap: () async => await _openLocaleMenu(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModalDialog(
      child: Column(
        children: [
          ListTile(
            leading: autoModeIcon,
            title: Text(autoModeString.tr),
            onTap: () {
              Get.back(result: MPaxThemeMode.auto);
            },
          ),
          ListTile(
            leading: lightModeIcon,
            title: Text(lightModeString.tr),
            onTap: () {
              Get.back(result: MPaxThemeMode.light);
            },
          ),
          ListTile(
            leading: darkModeIcon,
            title: Text(darkModeString.tr),
            onTap: () {
              Get.back(result: MPaxThemeMode.dark);
            },
          ),
        ],
      ),
    );
  }
}

class _LocaleMenu extends StatelessWidget {
  final List<Widget> _localeList = <Widget>[];

  List<Widget> _buildLocaleList() {
    _localeList.clear();
    const localMap = LocaleService.localeMap;

    // _localeList.add(ListTile(
    //   title: Text(LocaleService.autoLocale.tr),
    //   onTap: () {
    //     Get.back(result: LocaleService.autoLocale);
    //   },
    // ));

    for (final locale in localMap.keys) {
      _localeList.add(
        ListTile(
          title: Text(
            locale.tr,
          ),
          onTap: () => Get.back(result: locale),
        ),
      );
    }
    return _localeList;
  }

  @override
  Widget build(BuildContext context) {
    return ModalDialog(
      child: Column(
        children: _buildLocaleList(),
      ),
    );
  }
}
