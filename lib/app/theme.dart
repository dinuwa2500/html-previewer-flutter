import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1); // Modern Indigo
  static const Color accentColor = Color(0xFF38BDF8); // Cyan Accent

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      surface: const Color(0xFF131722),
      surfaceContainerLowest: const Color(0xFF0B0F17),
      surfaceContainerLow: const Color(0xFF131722),
      surfaceContainer: const Color(0xFF181F2C),
      surfaceContainerHigh: const Color(0xFF1E293B),
      outline: const Color(0xFF334155),
      outlineVariant: const Color(0xFF1E293B),
    ),
    scaffoldBackgroundColor: const Color(0xFF0B0F17),
    cardTheme: CardThemeData(
      color: const Color(0xFF131722),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0B0F17),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF1E293B),
      thickness: 1,
    ),
    fontFamily: '-apple-system',
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      surface: Colors.white,
      surfaceContainerLowest: const Color(0xFFF8FAFC),
      surfaceContainerLow: Colors.white,
      surfaceContainer: const Color(0xFFF1F5F9),
      surfaceContainerHigh: const Color(0xFFE2E8F0),
      outline: const Color(0xFFCBD5E1),
      outlineVariant: const Color(0xFFE2E8F0),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8FAFC),
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
      iconTheme: IconThemeData(color: Color(0xFF0F172A)),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8F0),
      thickness: 1,
    ),
    fontFamily: '-apple-system',
  );
}
