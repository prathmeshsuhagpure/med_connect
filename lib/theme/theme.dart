import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: Colors.grey.shade50,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

class DarkThemeColors {

  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Colors.grey;

  // Text
  static const Color textPrimary = Color(0xFFE5E7EB);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFF6B7280);

  // Buttons
  static const Color buttonPrimary = Color(0xFF2DD4BF); // teal 400
  static const Color buttonPrimaryText = Color(0xFF022C22);

  static const Color buttonSecondary = Color(0xFF1F2933);
  static const Color buttonSecondaryText = Color(0xFFE5E7EB);

  // Containers / Cards
  static const Color containerBg = Color(0xFF020617);
  static const Color containerBorder = Color(0xFF1E293B);

  static const Color containerButton = Color(0xFF134E4A); // dark teal
  static const Color containerButtonText = Color(0xFF99F6E4);
}


class LightThemeColors {
  // Text
  static const Color textPrimary = Color(0xFF0F172A); // near-black
  static const Color textSecondary = Color(0xFF475569); // slate
  static const Color textDisabled = Color(0xFF94A3B8);

  // Buttons
  static const Color buttonPrimary = Color(0xFF0D9488); // teal 600
  static const Color buttonPrimaryText = Colors.white;

  static const Color buttonSecondary = Color(0xFFE2E8F0);
  static const Color buttonSecondaryText = Color(0xFF0F172A);

  // Containers / Cards
  static const Color containerBg = Color(0xFFF8FAFC);
  static const Color containerBorder = Color(0xFFE2E8F0);

  static const Color containerButton = Color(0xFFCCFBF1); // teal 100
  static const Color containerButtonText = Color(0xFF0F766E); // teal 700
}



