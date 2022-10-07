import 'package:get/get.dart';

import 'translations_en_us.dart';
import 'translations_zh_cn.dart';

/// All translations for app.
class MPaxTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': translationEnUs,
        'zh_CN': translationZhCn,
      };
}
