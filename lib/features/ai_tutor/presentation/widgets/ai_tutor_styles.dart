import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// Shared decoration helpers for the AI Tutor screen so we can keep the
/// look-and-feel consistent across cards and form controls.
class AiTutorStyles {
  AiTutorStyles._();

  static BoxDecoration panelDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE1EEF3), Color(0xFFF6FBFD)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: AppColors.sidebarBorder),
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 22,
          offset: Offset(0, 16),
        ),
      ],
    );
  }

  static BoxDecoration sectionCard() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.sidebarBorder),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 12,
          offset: Offset(0, 12),
        ),
      ],
    );
  }

  static InputBorder inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: AppColors.sidebarBorder),
    );
  }
}
