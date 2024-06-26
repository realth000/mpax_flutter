import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

/// Global logger instance.
///
/// Initialize during app startup.
late final Logger logger;

/// Global service locator instance.
final sl = GetIt.instance;

/// Global instance of uuid provider.
const uuid = Uuid();
