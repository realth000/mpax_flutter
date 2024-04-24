part of 'models.dart';

/// All settings used in app.
@MappableClass()
final class SettingsModel with SettingsModelMappable {
  /// Constructor.
  SettingsModel({
    required this.themeMode,
    required this.locale,
    required this.accentColor,
  });

  /// Theme mode index.
  ///
  /// # Values
  ///
  /// 0: system
  /// 1: light
  /// 2: dark
  final int themeMode;

  /// User specified locale name.
  ///
  /// Empty locale means use system locale.
  final String locale;

  /// Accent color
  ///
  /// Zero value means default color.
  final int accentColor;
}

/// All keys in settings.
final class SettingsKeys {
  /// Theme mode index
  static const themeMode = 'ThemeMode';

  /// Locale name
  static const locale = 'Locale';

  /// Accent color value
  static const accentColor = 'AccentColor';
}
