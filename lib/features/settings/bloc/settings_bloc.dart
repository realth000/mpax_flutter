import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:mpax_flutter/features/logging/enums/loglevel.dart';
import 'package:mpax_flutter/features/settings/repository/settings_repository.dart';
import 'package:mpax_flutter/shared/models/models.dart';

part 'settings_bloc.mapper.dart';
part 'settings_event.dart';
part 'settings_state.dart';

/// Emitter type used in bloc.
typedef _Emit = Emitter<SettingsState>;

/// Bloc of settings feature.
///
/// All settings related logic run here.
final class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Constructor.
  ///
  /// Notice that we use the default settings when initializing bloc, because
  /// all database query is asynchronous, which is not allowed in constructor
  /// function. So use default settings to initialize first.
  ///
  /// The user of [SettingsBloc] MUST ensure that after bloc created, add
  /// [SettingsLoadAll] event to load all settings.
  SettingsBloc(this._repo)
      : super(SettingsState(settingsModel: _repo.getDefaultSettings())) {
    on<SettingsLoadAll>(_onSettingsLoadAll);
    on<SettingsModelChanged>(_onSettingsModelChanged);
    on<SettingsChangeThemeModeRequested>(_onSettingsChangeThemeModeRequested);
    on<SettingsChangeLocaleRequested>(_onSettingsChangeLocaleRequested);
    on<SettingsChangeAccentColorRequested>(
      _onSettingsChangeAccentColorRequested,
    );
    on<SettingsClearAccentColorRequested>(
      _onSettingClearAccentColorRequested,
    );
    on<SettingsChangeLoglevelRequested>(
      _onSettingsChangeLoglevelRequested,
    );
  }

  /// Repository instance.
  final SettingsRepository _repo;

  FutureOr<void> _onSettingsLoadAll(
    SettingsLoadAll event,
    _Emit emit,
  ) async {
    emit(state.copyWith(settingsModel: await _repo.getCurrentSettings()));
  }

  FutureOr<void> _onSettingsModelChanged(
    SettingsModelChanged event,
    _Emit emit,
  ) async {
    await _repo.setSettings(event.settingsModel);
    emit(state.copyWith(settingsModel: event.settingsModel));
  }

  FutureOr<void> _onSettingsChangeThemeModeRequested(
    SettingsChangeThemeModeRequested event,
    _Emit emit,
  ) async {
    await _repo.setThemeMode(event.themeIndex);
    final m = state.settingsModel.copyWith(themeMode: event.themeIndex);
    emit(state.copyWith(settingsModel: m));
  }

  FutureOr<void> _onSettingsChangeLocaleRequested(
    SettingsChangeLocaleRequested event,
    _Emit emit,
  ) async {
    await _repo.setLocale(event.locale);
    final m = state.settingsModel.copyWith(locale: event.locale);
    emit(state.copyWith(settingsModel: m));
  }

  FutureOr<void> _onSettingsChangeAccentColorRequested(
    SettingsChangeAccentColorRequested event,
    _Emit emit,
  ) async {
    await _repo.setAccentColor(event.color);
    final m = state.settingsModel.copyWith(accentColor: event.color.value);
    emit(state.copyWith(settingsModel: m));
  }

  FutureOr<void> _onSettingClearAccentColorRequested(
    SettingsClearAccentColorRequested event,
    _Emit emit,
  ) async {
    await _repo.clearAccentColor();
    // FIXME: NOT hardcode invalid settings value.
    final m = state.settingsModel.copyWith(accentColor: -1);
    emit(state.copyWith(settingsModel: m));
  }

  FutureOr<void> _onSettingsChangeLoglevelRequested(
    SettingsChangeLoglevelRequested event,
    _Emit emit,
  ) async {
    await _repo.setLoglevel(event.loglevel);
    final m = state.settingsModel.copyWith(loglevel: event.loglevel);
    emit(state.copyWith(settingsModel: m));
  }
}
