import 'package:flutter/material.dart';

class MPaxTheme {
  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF5152B7),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE1DFFF),
    onPrimaryContainer: Color(0xFF08006C),
    secondary: Color(0xFF5D5C72),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE2E0F9),
    onSecondaryContainer: Color(0xFF1A1A2C),
    tertiary: Color(0xFF795369),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8EC),
    onTertiaryContainer: Color(0xFF2E1124),
    error: Color(0xFFBA1A1A),
    errorContainer: Color(0xFFFFDAD6),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFFFFBFF),
    onBackground: Color(0xFF1C1B1F),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF1C1B1F),
    surfaceVariant: Color(0xFFE4E1EC),
    onSurfaceVariant: Color(0xFF47464F),
    outline: Color(0xFF777680),
    onInverseSurface: Color(0xFFF3EFF4),
    inverseSurface: Color(0xFF313034),
    inversePrimary: Color(0xFFC1C1FF),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFF5152B7),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFC1C1FF),
    onPrimary: Color(0xFF201E87),
    primaryContainer: Color(0xFF39399D),
    onPrimaryContainer: Color(0xFFE1DFFF),
    secondary: Color(0xFFC6C4DD),
    onSecondary: Color(0xFF2F2F42),
    secondaryContainer: Color(0xFF454559),
    onSecondaryContainer: Color(0xFFE2E0F9),
    tertiary: Color(0xFFE9B9D3),
    onTertiary: Color(0xFF46263A),
    tertiaryContainer: Color(0xFF5F3C51),
    onTertiaryContainer: Color(0xFFFFD8EC),
    error: Color(0xFFFFB4AB),
    errorContainer: Color(0xFF93000A),
    onError: Color(0xFF690005),
    onErrorContainer: Color(0xFFFFDAD6),
    background: Color(0xFF1C1B1F),
    onBackground: Color(0xFFE5E1E6),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE5E1E6),
    surfaceVariant: Color(0xFF47464F),
    onSurfaceVariant: Color(0xFFC8C5D0),
    outline: Color(0xFF918F9A),
    onInverseSurface: Color(0xFF1C1B1F),
    inverseSurface: Color(0xFFE5E1E6),
    inversePrimary: Color(0xFF5152B7),
    shadow: Color(0xFF000000),
    surfaceTint: Color(0xFFC1C1FF),
  );

  static final listTileTheme = ListTileThemeData(
    shape: RoundedRectangleBorder(
      // Larger enough to ensure material style.
      borderRadius: BorderRadius.circular(27.0),
    ),
    horizontalTitleGap: 10.0,
  );
  static const inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(),
  );

  static ThemeData light = ThemeData(
    colorScheme: lightColorScheme,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      // backgroundColor: lightColorScheme.primary,
      titleTextStyle: ThemeData.light().textTheme.titleLarge?.copyWith(
            // color: Colors.black,
            // fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
    ),
    listTileTheme: listTileTheme,
    inputDecorationTheme: inputDecorationTheme,
  );

  static ThemeData dark = ThemeData(
    colorScheme: darkColorScheme,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      titleTextStyle: ThemeData.dark().textTheme.titleLarge?.copyWith(
            // color: Colors.black,
            // fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
    ),
    listTileTheme: listTileTheme,
    inputDecorationTheme: inputDecorationTheme,
  );
}
