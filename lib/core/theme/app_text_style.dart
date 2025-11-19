import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // App Title (Aoboshi One)
  static TextStyle appTitle = GoogleFonts.aoboshiOne(
    fontSize: 40,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Button Text (Baloo 2)
  static TextStyle button = GoogleFonts.baloo2(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  // Headings (Baloo 2)
  static TextStyle heading1 = GoogleFonts.baloo2(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle heading2 = GoogleFonts.baloo2(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.baloo2(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Body Text
  static TextStyle bodyLarge = GoogleFonts.baloo2(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.baloo2(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle bodySmall = GoogleFonts.baloo2(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Caption / Subtitle
  static TextStyle caption = GoogleFonts.baloo2(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary.withOpacity(0.7),
  );
}
