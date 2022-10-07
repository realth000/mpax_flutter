import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

/// All app themes.
class MPaxTheme {
  /// Disable some style lints.
  final themeCount = 2;

  /// Global theme for [ListTile].
  static final listTileTheme = ListTileThemeData(
    shape: RoundedRectangleBorder(
      // Larger enough to ensure material style.
      borderRadius: BorderRadius.circular(27),
    ),
    horizontalTitleGap: 10,
  );

  /// Global theme for [TextField].
  static const inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  /// Main and original flex theme.
  static const flexScheme = FlexScheme.deepPurple;

  static final ThemeData _flexLightBase = FlexThemeData.light(
    scheme: flexScheme,
    colors: const FlexSchemeColor(
      primary: Color(0xff313196),
      primaryContainer: Color(0xffd1c4e9),
      secondary: Color(0xff0091ea),
      secondaryContainer: Color(0xffcfe4ff),
      tertiary: Color(0xff00b0ff),
      tertiaryContainer: Color(0xff9fcbf1),
      appBarColor: Color(0xffcfe4ff),
      error: Color(0xffb00020),
    ),
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 10,
    appBarOpacity: 0.95,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forBackground,
    tooltipsMatchBackground: true,
    subThemesData: const FlexSubThemesData(
      defaultRadius: 26,
      thickBorderWidth: 1.5,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primaryContainer,
      switchSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      radioSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      inputDecoratorRadius: 10,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      popupMenuOpacity: 0.98,
      popupMenuRadius: 8,
      dialogBackgroundSchemeColor: SchemeColor.onInverseSurface,
      navigationBarHeight: 65,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

  /// App light theme based on flex.
  static ThemeData flexLight = _flexLightBase.copyWith(
    // appBarTheme: AppBarTheme(),
    listTileTheme: listTileTheme,
    inputDecorationTheme: inputDecorationTheme,
  );

  static final ThemeData _flexDarkBase = FlexThemeData.dark(
    scheme: flexScheme,
    colors: const FlexSchemeColor(
      primary: Color(0xff313196),
      primaryContainer: Color(0xff7e57c2),
      secondary: Color(0xff80d8ff),
      secondaryContainer: Color(0xff00497b),
      tertiary: Color(0xff40c4ff),
      tertiaryContainer: Color(0xff0179b6),
      appBarColor: Color(0xff00497b),
      error: Color(0xffcf6679),
    ),
    surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
    blendLevel: 10,
    appBarOpacity: 0.95,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forBackground,
    surfaceTint: const Color(0xff311b92),
    tooltipsMatchBackground: true,
    subThemesData: const FlexSubThemesData(
      defaultRadius: 26,
      thickBorderWidth: 1.5,
      elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
      outlinedButtonOutlineSchemeColor: SchemeColor.primaryContainer,
      switchSchemeColor: SchemeColor.primary,
      checkboxSchemeColor: SchemeColor.primary,
      radioSchemeColor: SchemeColor.primary,
      unselectedToggleIsColored: true,
      inputDecoratorRadius: 10,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      popupMenuOpacity: 0.98,
      popupMenuRadius: 8,
      dialogBackgroundSchemeColor: SchemeColor.onInverseSurface,
      tabBarIndicatorSchemeColor: SchemeColor.inversePrimary,
      navigationBarHeight: 65,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
      useTertiary: true,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    // To use the playground font, add GoogleFonts package and uncomment
    // fontFamily: GoogleFonts.notoSans().fontFamily,
  );

// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

  /// App dark theme based on flex.
  static ThemeData flexDark = _flexDarkBase.copyWith(
    listTileTheme: listTileTheme,
    inputDecorationTheme: inputDecorationTheme,
  );
}
