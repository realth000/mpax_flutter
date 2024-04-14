part of 'models.dart';

/// All settings used in app.
@MappableClass()
final class SettingsModel with SettingsModelMappable {
  /// Constructor.
  SettingsModel({
    required this.themeMode,
  });

  final int themeMode;
}
