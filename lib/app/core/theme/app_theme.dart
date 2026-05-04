import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/static/app_colors.dart';
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      textTheme: TextTheme(
        /// Headings (Poppins, Bold/700)
        displayLarge: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: GoogleFonts.poppins(
          color: AppColors.textColor,
          fontWeight: FontWeight.w700,
        ),
        /// Body Text (Inter, Regular/400)
        bodyLarge: GoogleFonts.inter(
          color: AppColors.textColor,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.textColor,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.inter(
          color: AppColors.textColor,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.inter(
          color: AppColors.textColor,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: GoogleFonts.inter(
          color: AppColors.textColor,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: GoogleFonts.inter(
          color: AppColors.textColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

