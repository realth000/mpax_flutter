import 'dart:ui';

import 'package:get/get.dart';

import 'config_service.dart';

/// Locale (translation) service for app, globally.
class LocaleService extends GetxService {
  final _configService = Get.find<ConfigService>();

  /// Current using locale.
  RxString locale = ''.obs;

  /// Is following system locale, if true, system locale override.
  ///
  /// Not used yet as flutter is auto following and can not disable follow.
  bool followSystemLocale = true;

  /// Follow system locale string to show on UI.
  static const autoLocale = 'Follow system';

  /// Fallback locale, always English.
  static const fallbackLocale = Locale('en', 'US');

  /// All supported locales.
  static const localeMap = <String, Locale>{
    'en_US': Locale('en', 'US'),
    'zh_CN': Locale('zh', 'CN'),
  };

  /// Get locale should use.
  Locale getLocale() {
    if (followSystemLocale) {
      return window.locale;
    }
    if (localeMap.containsKey(locale.value)) {
      return localeMap[locale.value]!;
    }
    return fallbackLocale;
  }

  /// Change locale, if [localeName] is valid, change to that locale, otherwise
  /// auto changes.
  Future<bool> changeLocale(String? localeName) async {
    if (localeName == null) {
      return false;
    }
    // if (localeName == autoLocale) {
    //   if (localeMap.containsKey(
    //       '${window.locale.languageCode}_${window.locale.countryCode}')) {
    //     followSystemLocale = true;
    //  await _configService.saveBool('FollowSystemLocale', followSystemLocale);
    //     locale.value = autoLocale;
    //     await _configService.saveString('Locale', locale.value);
    //     await Get.updateLocale(window.locale);
    //     return true;
    //   } else {
    //     return false;
    //   }
    // }
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

  /// Init function, run before app start.
  Future<LocaleService> init() async {
    locale.value = _configService.getString('Locale') ??
        '${window.locale.languageCode}_${window.locale.countryCode}';
    followSystemLocale = _configService.getBool('FollowSystemLocale') ?? false;
    return this;
  }
}
