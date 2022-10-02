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

class _ThemeGroup {
  _ThemeGroup({required this.themeMode, required this.name});

  final MPaxThemeMode themeMode;
  final String name;
}

class _SettingsBodyWidget extends GetView<ConfigService> {
  final _themeService = Get.find<ThemeService>();
  final _localeService = Get.find<LocaleService>();

  final themeIcon = autoModeIcon.obs;
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
    final locale = await Get.dialog(_LocaleMenu());
    await _localeService.changeLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    if (_themeService.followSystemDarkMode) {
      _selections[1] = true;
    } else if (_themeService.useDarkTheme) {
      _selections[2] = true;
    } else {
      _selections[0] = true;
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
              Obx(
                () => ListTile(
                  leading: const ListTileLeading(
                    child: Icon(Icons.invert_colors),
                    // child: Icon(Icons.theme),
                  ),
                  title: Text('Theme'.tr),
                  subtitle: Text(_themeService.themeModeString.value.tr),
                  trailing: ToggleButtons(
                    onPressed: (index) {
                      if (_selections[index]) {
                        return;
                      }
                      for (var i = 0; i < _selections.length; i++) {
                        _selections[i] = false;
                      }
                      _selections[index] = true;
                      _themeService
                          .changeThemeMode(_themeList[index].themeMode);
                    },
                    isSelected: _selections,
                    children: _themeIcons,
                  ),
                ),
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

class _LocaleMenu extends StatelessWidget {
  final List<Widget> _localeList = <Widget>[];

  List<Widget> _buildLocaleList() {
    _localeList.clear();
    const localMap = LocaleService.localeMap;

    _localeList.add(ListTile(
      title: Text(LocaleService.autoLocale.tr),
      onTap: () {
        Get.back(result: LocaleService.autoLocale);
      },
    ));

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
  Widget build(BuildContext context) {
    return ModalDialog(
      child: Column(
        children: _buildLocaleList(),
      ),
    );
  }
}
