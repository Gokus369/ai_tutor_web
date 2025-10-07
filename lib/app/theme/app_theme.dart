import 'package:flutter/material.dart';

import '../../shared/styles/app_colors.dart';
import '../../shared/styles/app_typography.dart';

/// Central place for Material [ThemeData] definitions.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final baseTextTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.primary,
      ),
      textTheme: baseTextTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: baseTextTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.checkboxBorder, width: 1.2),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.white;
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 38),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTypography.button,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        contentTextStyle: baseTextTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }
}
