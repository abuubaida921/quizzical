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

  // Headings (Aoboshi One)
  static TextStyle heading1 = GoogleFonts.aoboshiOne(
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Headings (Amethysta)
  static TextStyle heading1SubTitle = GoogleFonts.amethysta(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.subTextPrimary,
  );

  static TextStyle heading2 = GoogleFonts.baloo2(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle heading3 = GoogleFonts.baloo2(
    fontSize: 16,
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

  static TextStyle sectionTitle = GoogleFonts.baloo2(
    fontSize: 23,
    fontWeight: FontWeight.bold,
    color: AppColors.onPrimary,
  );

  // Cat Title
  static TextStyle catTitle = GoogleFonts.baloo2(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: AppColors.categoryTitlePrimary,
  );
}
