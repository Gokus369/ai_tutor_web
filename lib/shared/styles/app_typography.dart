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
        color: AppColors.greyMedium,
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

  static TextStyle get dashboardTitle => GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: 0.2,
      );

  static TextStyle get sectionTitle => GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get metricValue => GoogleFonts.nunitoSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get metricLabel => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
        letterSpacing: 0.2,
      );

  static TextStyle get quickAction => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.quickActionContent,
      );

  static TextStyle get sidebarItem => GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.sidebarIcon.withValues(alpha: 0.85),
      );

  static TextStyle get sidebarItemActive => GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textInverse,
      );

  static TextStyle statusChip(Color textColor) => GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: textColor,
      );

  static TextStyle get tableHeader => GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.greyDark,
        letterSpacing: 0.2,
      );

  static TextStyle get tableCell => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get tableLink => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      );

  static TextStyle get classCardTitle => GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get classCardBadge => GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.classBadgeText,
      );

  static TextStyle get classCardMeta => GoogleFonts.nunitoSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.classMetaText,
      );

  static TextStyle get classCardDescription => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.classMetaText,
        height: 1.4,
      );

  static TextStyle get classProgressLabel => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.classMetaText,
      );

  static TextStyle get classProgressValue => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );
}
