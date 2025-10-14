import 'package:flutter/material.dart';

/// Centralised color palette for AiTutor UI elements.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFCFDFD);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFF235A6E);
  static const Color primaryDark = Color(0xFF23616E);
  static const Color accent = Color(0xFF235A6E);

  static const Color textPrimary = Color(0xFF202224);
  static const Color textSecondary = Color(0xFF404040);
  static const Color textMuted = Color(0xFF8A8C8F);
  static const Color textInverse = Color(0xFFFFFFFF);

  static const Color iconMuted = Color(0xFF979797);
  static const Color iconForeground = Color(0xFF23616E);

  static const Color border = Color(0xFFD8D8D8);
  static const Color borderMuted = Color(0xFFD5D5D5);
  static const Color checkboxBorder = Color(0xFF235A6E);

  static const Color shadow = Color(0x332B3034);

  static const Color sidebarBackground = Color(0xFF0D3B44);
  static const Color sidebarActive = Color(0xFF235A6E);
  static const Color sidebarHover = Color(0xFF13454E);
  static const Color sidebarIcon = Color(0xFF565656);
  static const Color sidebarSurface = Color(0xFFFFFFFF);
  static const Color sidebarBorder = Color(0xFFE3EDF2);

  static const Color dashboardGradientTop = Color(0xFFF5F6FA);
  static const Color dashboardGradientBottom = Color(0xFFE9F1F4);

  static const Color quickActionBlue = Color(0xFF165DFB);
  static const Color quickActionGreen = Color(0xFF00A63E);
  static const Color quickActionPurple = Color(0xFF9810FA);
  static const Color quickActionOrange = Color(0xFFF54900);
  static const Color quickActionContent = Color(0xFFFFFFFF);

  static const Color metricIconBlue = Color(0xFF8280FF);
  static const Color metricIconGreen = Color(0xFF4AD991);
  static const Color metricIconYellow = Color(0xFFFEC53D);
  static const Color metricIconPeach = Color(0xFFFF9066);

  static const Color summaryCardGradientStart = Color(0xFFFCFDFD);
  static const Color summaryCardGradientEnd = Color(0xFFECECEC);
  static const Color summaryCardBorder = Color(0xFFD5D5D5);
  static const Color summaryTileBackground = Color(0xFFF5F6FA);

  static const Color quickActionsContainer = Color(0xFFFCFDFD);
  static const Color quickActionsTitle = Color(0xFF202224);

  static const Color statusCompletedBackground = Color(0xFF00B69B);
  static const Color statusCompletedText = Color(0xFFFFFFFF);
  static const Color statusPendingBackground = Color(0xFFFCBE2D);
  static const Color statusPendingText = Color(0xFF404040);
  static const Color statusScheduledBackground = Color(0xFF165DFB);
  static const Color statusScheduledText = Color(0xFFFFFFFF);
  static const Color statusErrorBackground = Color(0xFFFF4343);
  static const Color statusErrorText = Color(0xFFFFFFFF);

  static const Color searchFieldBackground = Color(0xFFF5F6FA);
  static const Color searchFieldBorder = Color(0xFFD5D5D5);

  static const Color tableHeaderBackground = Color(0xFFE9F1F4);
  static const Color tableRowDivider = Color(0xFFD5D5D5);
  static const Color tableRowBackground = Color(0xFFFCFDFD);

  static const Color overlayDark = Color(0x992B3034);
  static const Color overlayHighlight = Color(0x9CF93C65);

  static const Color accentOrange = Color(0xFFF54900);
  static const Color accentCoral = Color(0xFFFF9066);
  static const Color accentYellow = Color(0xFFFEC53D);
  static const Color accentPink = Color(0xFFF93C65);
  static const Color accentPinkTransparent = Color(0x9CF93C65);
  static const Color accentRed = Color(0xFFFF0000);
  static const Color accentTeal = Color(0xFF00B69B);
  static const Color accentGreen = Color(0xFF00A63E);
  static const Color accentPurple = Color(0xFF9810FA);
  static const Color accentBlue = Color(0xFF165DFB);

  static const Color greyDark = Color(0xFF404040);
  static const Color greyMedium = Color(0xFF5C5C5C);
  static const Color grey = Color(0xFF565656);
  static const Color greyMuted = Color(0xFF8A8C8F);
  static const Color greyLight = Color(0xFFD8D8D8);
  static const Color greyExtraLight = Color(0xFFECECEC);

  static const Color classCardBackground = Color(0xFFF5F6FA);
  static const Color classCardBorder = Color(0xFFD5D5D5);
  static const Color classCardShadow = Color(0x0D000000);
  static const Color classBadgeBackground = Color(0xFFDEDDFF);
  static const Color classBadgeText = Color(0xFF5452FF);
  static const Color classStudentIconBackground = Color(0xFFFF9DB2);
  static const Color classSubjectIconBackground = Color(0xFFDEDDFF);
  static const Color classSubjectIconColor = Color(0xFF9810FA);
  static const Color classMetaText = Color(0xFF565656);
  static const Color classProgressTrack = Color(0xFFE0E0E0);
  static const Color classProgressValue = Color(0xFF23616E);

  static const Color syllabusBackground = Color(0xFFFCFDFD);
  static const Color syllabusSectionBackground = Color(0xFFF5F6FA);
  static const Color syllabusCardBorder = Color(0xFFD5D5D5);
  static const Color syllabusDivider = Color(0xFFE0E0E0);
  static const Color syllabusSearchBorder = Color(0xFFDBDBDB);
  static const Color syllabusSearchBackground = Color(0xFFE8F0F3);
  static const Color syllabusStatusInProgress = Color(0xFFFF8C00);
  static const Color syllabusStatusCompleted = Color(0xFF00B69B);
  static const Color syllabusStatusText = Color(0xFFFFFFFF);
  static const Color syllabusMuted = Color(0xFF7E7E7E);
  static const Color syllabusProgressTrack = Color(0xFFE0E0E0);
  static const Color syllabusProgressValue = Color(0xFF23616E);
  static const Color syllabusOverlay = Color(0xB22B3034);

  static const Color studentsBackground = Color(0xFFF5F6FA);
  static const Color studentsCardBackground = Color(0xFFFCFDFD);
  static const Color studentsCardBorder = Color(0xFFD5D5D5);
  static const Color studentsHeaderBackground = Color(0xFFE9F1F4);
  static const Color studentsSearchBackground = Color(0xFFE8F0F3);
  static const Color studentsSearchBorder = Color(0xFFD5D5D5);
  static const Color studentsFilterBackground = Color(0xFFFCFDFD);
  static const Color studentsFilterBorder = Color(0xFFD5D5D5);
  static const Color studentsTableDivider = Color(0xFFE0E0E0);
  static const Color studentsProgressTrack = Color(0xFFE0E0E0);
  static const Color studentsProgressValue = Color(0xFF23616E);
  static const Color studentsPerformanceTop = Color(0xFF00B69B);
  static const Color studentsPerformanceAverage = Color(0xFFF9B61A);
  static const Color studentsPerformanceAttention = Color(0xFFFF2B2B);
  static const Color studentsStatusActive = Color(0xFF00B69B);
  static const Color studentsStatusInactive = Color(0xFF121417);

  static const Color progressCardBorder = Color(0xFFD2EBF7);
  static const Color progressSectionBorder = Color(0xFFB4DCEF);
  static const Color progressSectionBackground = Color(0xFFF3FAFD);
  static const Color progressSecondaryBackground = Color(0xFFF7FBFD);
  static const Color progressModuleBorder = Color(0xFFC9E3F3);
  static const Color progressChipBackground = Color(0xFFE8F4F8);
  static const Color progressChipBorder = Color(0xFFB1DAED);
  static const Color progressMetricTrack = Color(0xFFE2EFF6);
}
