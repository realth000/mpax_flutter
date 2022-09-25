import 'dart:ui';

import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';

class LocaleService extends GetxService {
  final _configService = Get.find<ConfigService>();
  var locale = ''.obs;
  bool followSystemLocale = true;

  static const autoLocale = 'Follow system';
  static const fallbackLocale = Locale('en', 'US');
  static const localeMap = <String, Locale>{
    'en_US': Locale('en', 'US'),
    'zh_CN': Locale('zh', 'CN'),
  };

  Locale getLocale() {
    // if (followSystemLocale) {
    //   return window.locale;
    // }
    if (localeMap.containsKey(locale.value)) {
      return localeMap[locale.value]!;
    }
    return fallbackLocale;
  }

  Future<bool> changeLocale(String? localeName) async {
    if (localeName == null) {
      return false;
    }
    if (localeName == autoLocale || false) {
      if (localeMap.containsKey(
          '${window.locale.languageCode}_${window.locale.countryCode}')) {
        followSystemLocale = true;
        await _configService.saveBool('FollowSystemLocale', followSystemLocale);
        locale.value = autoLocale;
        await _configService.saveString('Locale', locale.value);
        await Get.updateLocale(window.locale);
        return true;
      } else {
        return false;
      }
    }
    if (localeMap.containsKey(localeName)) {
      followSystemLocale = false;
      await _configService.saveBool('FollowSystemLocale', followSystemLocale);
      locale.value = localeName;
      await _configService.saveString('Locale', locale.value);
      await Get.updateLocale(localeMap[localeName]!);
      return true;
    }
    return false;
  }

  Future<LocaleService> init() async {
    locale.value = _configService.getString('Locale') ??
        '${window.locale.languageCode}_${window.locale.countryCode}';
    followSystemLocale = _configService.getBool('FollowSystemLocale') ?? false;
    return this;
  }
}
