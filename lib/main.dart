import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'app.dart';
import 'features/logging/repository/logging_repository_impl.dart';
import 'features/settings/repository/settings_repository.dart';
import 'features/settings/repository/settings_repository_impl.dart';
import 'i18n/strings.g.dart';
import 'instance.dart';
import 'shared/providers/storage_provider/database/database.dart';
import 'shared/providers/storage_provider/storage_provider.dart';
import 'shared/providers/storage_provider/storage_provider_impl.dart';

/// Initialize all dependencies.
Future<void> initializeDependencies() async {
  sl
    ..registerSingleton<LogOutput>(LoggingRepositoryImpl())
    ..registerFactory<AppDatabase>(AppDatabase.new)
    ..registerSingleton<StorageProvider>(StorageProviderImpl(sl()))
    ..registerFactory<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  await sl.allReady();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  // Preload part of settings.
  // Do NOT set settings here.
  final sr = sl.get<SettingsRepository>();
  final loglevel = await sr.getLoglevel();
  // Setup logger asap.
  logger = Logger(
    level: loglevel.toLevel,
    printer: SimplePrinter(printTime: true),
    output: sl(),
  );
  if (kDebugMode) {
    print('[main] init logger with loglevel $loglevel');
  }
  logger.i('logger setup: loglevel=$loglevel');
  final settingsLocale = await sr.getLocale();
  final themeMode = await sr.getThemeMode();

  final locale =
      AppLocale.values.firstWhereOrNull((v) => v.languageTag == settingsLocale);
  if (locale == null) {
    LocaleSettings.useDeviceLocale();
  } else {
    LocaleSettings.setLocale(locale);
  }

  runApp(
    TranslationProvider(
      child: App(themeMode: themeMode),
    ),
  );
}
