part of 'settings_bloc.dart';

/// Status of [SettingsState].
enum SettingsStatus {
  /// Initial state.
  initial,

  /// Load settings finished and succeed.
  success,
}

/// State of settings bloc.
@MappableClass()
final class SettingsState with SettingsStateMappable {
  /// Constructor.
  const SettingsState({
    required this.settingsModel,
    this.status = SettingsStatus.initial,
  });

  /// State status.
  final SettingsStatus status;

  /// Current settings values.
  final SettingsModel settingsModel;
}
