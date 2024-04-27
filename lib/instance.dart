import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

/// Global logger instance.
///
/// Initialize during app startup.
late final Logger logger;

/// Global service locator instance.
final sl = GetIt.instance;
