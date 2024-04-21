import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'i18n/strings.g.dart';
import 'routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: context.t.appName,
      routerConfig: routerConfig,
      locale: TranslationProvider.of(context).flutterLocale,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
