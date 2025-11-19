import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary color
  static const int _primaryValue = 0xFF0F7B71;
  static const Color primary = Color(_primaryValue);

  // Primary variants / accents
  static const Color primaryVariant = Color(0xFF0B625B);
  static const Color secondary = Color(0xFF6C4DF5);

  // Background / surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F9FB);

  // Text / on-colors
  static const Color textPrimary = Color(0xFF000000);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Shadows (alpha ~ 0.18 -> 0x2E)
  static const Color shadow = Color(0x2E000000);

  // Convenient MaterialColor swatch for ThemeData
  static const MaterialColor primarySwatch = MaterialColor(
    _primaryValue,
    <int, Color>{
      50: Color(0xFFE7F6F5),
      100: Color(0xFFCFECE9),
      200: Color(0xFF9FDED2),
      300: Color(0xFF6FCFBB),
      400: Color(0xFF2FBFA3),
      500: Color(_primaryValue),
      600: Color(0xFF0E6F64),
      700: Color(0xFF0B625B),
      800: Color(0xFF0A5450),
      900: Color(0xFF05322A),
    },
  );
}
