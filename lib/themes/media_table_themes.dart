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
      gridBackgroundColor: Colors.transparent,
      rowColor: Colors.transparent,
      activatedColor: MPaxTheme.flexLight.colorScheme.primary.withOpacity(0.6),
      activatedBorderColor: Colors.transparent,
      gridBorderColor: Colors.grey,
      borderColor: Colors.transparent,
      gridBorderRadius: BorderRadius.circular(5),
    ),
  );

  /// Dark theme of MediaTable.
  static final darkTheme = const PlutoGridConfiguration.dark().copyWith(
    columnSize: const PlutoGridColumnSizeConfig(
      autoSizeMode: PlutoAutoSizeMode.scale,
    ),
    style: PlutoGridStyleConfig(
      gridBackgroundColor: Colors.transparent,
      rowColor: Colors.transparent,
      activatedColor: MPaxTheme.flexLight.colorScheme.primary.withOpacity(0.6),
      activatedBorderColor: Colors.transparent,
      gridBorderColor: Colors.grey,
      borderColor: Colors.transparent,
      gridBorderRadius: BorderRadius.circular(5),
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
