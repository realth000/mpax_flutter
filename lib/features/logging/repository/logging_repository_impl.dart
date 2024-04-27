import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../../instance.dart';
import 'logging_repository.dart';

/// The implementation of [LoggingRepository].
final class LoggingRepositoryImpl implements LoggingRepository {
  /// Save all logs.
  final List<String> _logs = [];

  @override
  List<String> get allLog => _logs;

  @override
  FutureOr<void> saveToFile(String filePath) async {
    logger.i('save log');
    await File(filePath).writeAsString(_logs.join('\n'));
  }

  @override
  void clearLog() {
    logger.i('clear log');
    _logs.clear();
  }

  @override
  Future<void> destroy() async {}

  @override
  Future<void> init() async {}

  @override
  void output(OutputEvent event) {
    _logs.addAll(event.lines);
    if (kDebugMode) {
      for (final line in event.lines) {
        print(line);
      }
    }
  }
}
