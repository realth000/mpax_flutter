import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart' as l;

import '../../../i18n/strings.g.dart';

/// App wide loglevel definition.
enum Loglevel {
  /// [l.Level.debug].
  debug,

  /// [l.Level.info].
  info,

  /// [l.Level.warning].
  warning,

  /// [l.Level.error].
  error,

  /// [l.Level.off].
  off;

  /// Convert into logger used loglevel.
  l.Level get toLevel => switch (this) {
        Loglevel.debug => l.Level.debug,
        Loglevel.info => l.Level.info,
        Loglevel.warning => l.Level.warning,
        Loglevel.error => l.Level.error,
        Loglevel.off => l.Level.off,
      };

  /// Translate into string.
  String tr(BuildContext context) {
    final tr = context.t.settingsPage.debug;
    return switch (this) {
      Loglevel.debug => tr.loglevel.debug,
      Loglevel.info => tr.loglevel.info,
      Loglevel.warning => tr.loglevel.warning,
      Loglevel.error => tr.loglevel.error,
      Loglevel.off => tr.loglevel.off,
    };
  }
}
