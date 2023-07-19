import 'package:get/get.dart';

import 'package:mpax_flutter/translations/translations_en_us.dart';
import 'package:mpax_flutter/translations/translations_zh_cn.dart';

/// All translations for app.
class MPaxTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': translationEnUs,
        'zh_CN': translationZhCn,
      };
}
