import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Text style helpers to keep typography consistent across the app.
class AppTypography {
  AppTypography._();

  static TextTheme get textTheme => GoogleFonts.nunitoSansTextTheme();

  static TextStyle get brandWordmark => GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
        height: 1,
      );

  static TextStyle get subtitle => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get signupTitle => GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1,
        letterSpacing: 0.3,
      );

  static TextStyle get formLabel => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get linkSmall => GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      );

  static TextStyle get button => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
