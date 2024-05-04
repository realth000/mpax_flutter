import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mpax_flutter/app.dart';
import 'package:mpax_flutter/features/logging/repository/logging_repository_impl.dart';
import 'package:mpax_flutter/features/metadata/repository/metadata_repository.dart';
import 'package:mpax_flutter/features/metadata/repository/metadata_taglib_repository_impl.dart';
import 'package:mpax_flutter/features/music_library/repository/music_library_repository.dart';
import 'package:mpax_flutter/features/music_library/repository/music_library_repository_impl.dart';
import 'package:mpax_flutter/features/settings/repository/settings_repository.dart';
import 'package:mpax_flutter/features/settings/repository/settings_repository_impl.dart';
import 'package:mpax_flutter/i18n/strings.g.dart';
import 'package:mpax_flutter/instance.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/database/database.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider.dart';
import 'package:mpax_flutter/shared/providers/storage_provider/storage_provider_impl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:taglib_ffi_dart/taglib_ffi_dart.dart' as taglib;

/// Initialize all dependencies.
Future<void> initializeDependencies() async {
  final imageCacheDir =
      '${(await getApplicationSupportDirectory()).path}/image';

  sl
    ..registerSingleton<LogOutput>(LoggingRepositoryImpl())
    ..registerFactory<AppDatabase>(AppDatabase.new)
    ..registerSingleton<StorageProvider>(
      StorageProviderImpl(sl(), imageCacheDir),
    )
    ..registerFactory<SettingsRepository>(() => SettingsRepositoryImpl(sl()))
    ..registerFactory<MusicLibraryRepository>(MusicLibraryRepositoryImpl.new)
    ..registerFactory<MetadataRepository>(MetadataTaglibRepositoryImpl.new);
  await sl.allReady();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await taglib.initialize();
  await initializeDependencies();

  // Preload part of settings.
  // Do NOT set settings here.
  final sr = sl.get<SettingsRepository>();
  final loglevel = await sr.getLoglevel();
  // Setup logger asap.
  logger = Logger(
    level: loglevel.toLevel,
    printer: SimplePrinter(printTime: true, colors: false),
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
      child: ResponsiveBreakpoints.builder(
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
        child: App(themeMode: themeMode),
      ),
    ),
  );
}
