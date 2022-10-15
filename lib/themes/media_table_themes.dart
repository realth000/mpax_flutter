import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'app_themes.dart';

/// Theme for MediaTable.
class MediaTableTheme {
  /// Disable all static lint.
  final themeCount = 2;

  /// Light theme of MediaTable.
  static final lightTheme = const PlutoGridConfiguration().copyWith(
    columnSize: const PlutoGridColumnSizeConfig(
      autoSizeMode: PlutoAutoSizeMode.scale,
    ),
    style: PlutoGridStyleConfig(
      gridBackgroundColor: MPaxTheme.flexLight.colorScheme.surface,
      rowColor: MPaxTheme.flexLight.colorScheme.surface,
      activatedColor: MPaxTheme.flexLight.colorScheme.primary.withOpacity(0.6),
      activatedBorderColor:
          MPaxTheme.flexLight.colorScheme.primary.withOpacity(0.6),
      gridBorderColor: Colors.transparent,
      borderColor: Colors.transparent,
      gridBorderRadius: BorderRadius.circular(26),
      iconColor: Colors.black.withOpacity(0.6),
      cellColorInEditState: MPaxTheme.flexLight.colorScheme.onInverseSurface,
      rowHeight: 35,
    ),
  );

  /// Dark theme of MediaTable.
  static final darkTheme = const PlutoGridConfiguration.dark().copyWith(
    columnSize: const PlutoGridColumnSizeConfig(
      autoSizeMode: PlutoAutoSizeMode.scale,
    ),
    style: PlutoGridStyleConfig(
      gridBackgroundColor: MPaxTheme.flexDark.colorScheme.surface,
      rowColor: MPaxTheme.flexDark.colorScheme.surface,
      activatedColor: MPaxTheme.flexLight.colorScheme.primary.withOpacity(0.6),
      activatedBorderColor:
          MPaxTheme.flexLight.colorScheme.primary.withOpacity(0.6),
      gridBorderColor: Colors.transparent,
      borderColor: Colors.transparent,
      gridBorderRadius: BorderRadius.circular(26),
      iconColor: Colors.white.withOpacity(0.8),
      disabledIconColor: Colors.white.withOpacity(0.4),
      cellColorInEditState: MPaxTheme.flexDark.colorScheme.onInverseSurface,
      rowHeight: 35,
      // Fix text style.
      columnTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.8),
        decoration: TextDecoration.none,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      cellTextStyle: TextStyle(
        color: Colors.white.withOpacity(0.8),
        fontSize: 14,
      ),
    ),
  );
}
