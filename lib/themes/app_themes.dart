import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const _cardTheme = CardTheme(
    elevation: 1,
  );

  static const _chipTheme = ChipThemeData(
    padding: EdgeInsets.all(2),
  );

  static final String? _fontFamily = null;

  /// Global theme for [ListTile].
  static const _listTileTheme = ListTileThemeData(
    visualDensity: VisualDensity.standard,
    contentPadding: EdgeInsets.symmetric(horizontal: 10),
    horizontalTitleGap: 10,
  );

  static ThemeData makeLight([Color? seedColor]) {
    ColorScheme? seedScheme;
    if (seedColor != null) {
      seedScheme = ColorScheme.fromSeed(seedColor: seedColor);
    }
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xff004881),
        primaryContainer: Color(0xffd0e4ff),
        secondary: Color(0xffac3306),
        secondaryContainer: Color(0xffffdbcf),
        tertiary: Color(0xff006875),
        tertiaryContainer: Color(0xff95f0ff),
        appBarColor: Color(0xffffdbcf),
        error: Color(0xffb00020),
      ),
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        blendOnColors: false,
        useTextTheme: true,
        inputDecoratorBorderType: FlexInputBorderType.underline,
        inputDecoratorUnfocusedBorderIsColored: false,
        alignedDropdown: true,
        tooltipRadius: 4,
        tooltipSchemeColor: SchemeColor.inverseSurface,
        tooltipOpacity: 0.9,
        useInputDecoratorThemeInDialogs: true,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
        bottomNavigationBarShowUnselectedLabels: false,
        navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarIndicatorOpacity: 1.00,
        navigationBarLabelBehavior:
            NavigationDestinationLabelBehavior.onlyShowSelected,
        navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        navigationRailLabelType: NavigationRailLabelType.none,
      ),
      keyColors: const FlexKeyColors(),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the Playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }

  /// App dark themes.
  static ThemeData makeDark([Color? seedColor]) {
    ColorScheme? seedScheme;
    if (seedColor != null) {
      seedScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      );
    }
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: Color(0xff14148e),
        primaryContainer: Color(0xff00325b),
        secondary: Color(0xffffb59d),
        secondaryContainer: Color(0xff872100),
        tertiary: Color(0xff86d2e1),
        tertiaryContainer: Color(0xff004e59),
        appBarColor: Color(0xff872100),
        error: Color(0xffcf6679),
      ),
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        useTextTheme: true,
        inputDecoratorBorderType: FlexInputBorderType.underline,
        inputDecoratorUnfocusedBorderIsColored: false,
        alignedDropdown: true,
        tooltipRadius: 4,
        tooltipSchemeColor: SchemeColor.inverseSurface,
        tooltipOpacity: 0.9,
        useInputDecoratorThemeInDialogs: true,
        snackBarElevation: 6,
        snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
        bottomNavigationBarShowUnselectedLabels: false,
        navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedLabel: false,
        navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationBarMutedUnselectedIcon: false,
        navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationBarIndicatorOpacity: 1.00,
        navigationBarLabelBehavior:
            NavigationDestinationLabelBehavior.onlyShowSelected,
        navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedLabel: false,
        navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
        navigationRailMutedUnselectedIcon: false,
        navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
        navigationRailIndicatorOpacity: 1.00,
        navigationRailBackgroundSchemeColor: SchemeColor.surface,
        navigationRailLabelType: NavigationRailLabelType.none,
      ),
      keyColors: const FlexKeyColors(),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      // To use the Playground font, add GoogleFonts package and uncomment
      // fontFamily: GoogleFonts.notoSans().fontFamily,
    );
  }
}
