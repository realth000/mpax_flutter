import 'package:flutter/material.dart';

import 'app.dart';
import 'i18n/strings.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocaleSettings.useDeviceLocale();

  runApp(TranslationProvider(
    child: const App(),
  ));
}
