import 'dart:ui';

import 'package:get/get.dart';
import 'package:mpax_flutter/services/config_service.dart';

class LocalService extends GetxService {
  final _configService = Get.find<ConfigService>();
  String locale = '';
  bool followSystemLocale = true;

  static const autoLocale = 'auto';
  static const fallbackLocale = Locale('en', 'US');
  static const localMap = <String, Locale>{
    'en_US': Locale('en', 'US'),
    'zh_CN': Locale('zh', 'CN'),
  };

  Locale getLocale() {
    if (followSystemLocale) {
      return window.locale;
    }
    if (localMap.containsKey(locale)) {
      return localMap[locale]!;
    }
    return fallbackLocale;
  }

  void changeLocale(String? localeName) {
    if (localeName == null) {
      return;
    }
    if (localeName == autoLocale) {
      if (localMap.containsKey(window.locale)) {
        followSystemLocale = true;
        _configService.saveBool('FollowSystemLocale', followSystemLocale);
        Get.updateLocale(window.locale);
      }
      return;
    }
    if (localMap.containsKey(localeName)) {
      followSystemLocale = false;
      _configService.saveBool('FollowSystemLocale', followSystemLocale);
      locale = localeName;
      _configService.saveString('Locale', locale);
      Get.updateLocale(localMap[localeName]!);
      return;
    }
  }

  Future<LocalService> init() async {
    locale = _configService.getString('Locale') ?? 'en_US';
    followSystemLocale = _configService.getBool('FollowSystemLocale') ?? true;
    return this;
  }
}
