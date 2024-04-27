part of 'settings_bloc.dart';

/// Event of app settings.
@MappableClass()
sealed class SettingsEvent with SettingsEventMappable {
  const SettingsEvent();
}

/// Force load all settings data.
///
/// Use this to initialize or refresh settings.
@MappableClass()
final class SettingsLoadAll extends SettingsEvent with SettingsLoadAllMappable {
  /// Constructor.
  const SettingsLoadAll() : super();
}

/// Settings value changed.
///
/// This is a passive event triggered in bloc.
@MappableClass()
final class SettingsModelChanged extends SettingsEvent
    with SettingsModelChangedMappable {
  /// Constructor.
  const SettingsModelChanged(this.settingsModel) : super();

  /// Latest settings.
  final SettingsModel settingsModel;
}

/// User requested to change the the mode.
@MappableClass()
final class SettingsChangeThemeModeRequested extends SettingsEvent
    with SettingsChangeThemeModeRequestedMappable {
  /// Constructor.
  const SettingsChangeThemeModeRequested(this.themeIndex) : super();

  /// Theme mode index to use.
  final int themeIndex;
}

/// User required to changed the app locale.
@MappableClass()
final class SettingsChangeLocaleRequested extends SettingsEvent
    with SettingsChangeLocaleRequestedMappable {
  /// Constructor.
  const SettingsChangeLocaleRequested(this.locale) : super();

  /// Locale to use.
  final String locale;
}

/// User required to changed the accent color of the app.
@MappableClass()
final class SettingsChangeAccentColorRequested extends SettingsEvent
    with SettingsChangeAccentColorRequestedMappable {
  /// Constructor.
  const SettingsChangeAccentColorRequested(this.color) : super();

  /// Color to seed theme from.
  final Color color;
}

/// User required to unset the current app accent color.
@MappableClass()
final class SettingsClearAccentColorRequested extends SettingsEvent
    with SettingsClearAccentColorRequestedMappable {
  /// Constructor.
  const SettingsClearAccentColorRequested() : super();
}

/// User requested to change loglevel.
///
/// This only make effect after app reboot.
@MappableClass()
final class SettingsChangeLoglevelRequested extends SettingsEvent
    with SettingsChangeLoglevelRequestedMappable {
  /// Constructor.
  const SettingsChangeLoglevelRequested(this.loglevel) : super();

  /// [Loglevel] to apply.
  final Loglevel loglevel;
}
