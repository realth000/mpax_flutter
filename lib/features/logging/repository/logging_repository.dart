import 'dart:async';

import 'package:logger/logger.dart';

/// Define logging access.
abstract interface class LoggingRepository extends LogOutput {
  /// Get all the log output.
  List<String> get allLog;

  /// Save all log to file.
  FutureOr<void> saveToFile(String filePath);

  /// Clear saved log.
  void clearLog();
}
