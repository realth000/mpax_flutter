import 'package:flutter/material.dart';

import 'app.dart';
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
    ..registerFactory<AppDatabase>(AppDatabase.new)
    ..registerSingleton<StorageProvider>(StorageProviderImpl(sl()))
    ..registerSingleton<SettingsRepository>(SettingsRepositoryImpl(sl()));
  await sl.allReady();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  LocaleSettings.useDeviceLocale();

  runApp(
    TranslationProvider(
      child: const App(),
    ),
  );
}
