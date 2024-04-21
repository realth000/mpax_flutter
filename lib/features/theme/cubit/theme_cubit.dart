import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'theme_cubit.mapper.dart';
part 'theme_state.dart';

/// Cubit controlling app theme.
final class ThemeCubit extends Cubit<ThemeState> {
  /// Constructor.
  ThemeCubit({
    Color? accentColor,
    int themeModeIndex = 0,
  }) : super(
          ThemeState(
            accentColor: accentColor,
            themeModeIndex: themeModeIndex,
          ),
        );

  /// Set the accent color.
  void setAccentColor(Color accentColor) =>
      emit(state.copyWith(accentColor: accentColor));

  /// Reset the app accent color.
  void clearAccentColor() =>
      emit(ThemeState(themeModeIndex: state.themeModeIndex));

  /// Set the app the mode by its index.
  void setThemeModeIndex(int themeModeIndex) =>
      emit(state.copyWith(themeModeIndex: themeModeIndex));
}
