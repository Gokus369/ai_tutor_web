import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// Shared decoration helpers for the AI Tutor screen so we can keep the
/// look-and-feel consistent across cards and form controls.
class AiTutorStyles {
  AiTutorStyles._();

  static BoxDecoration panelDecoration() {
    final Color borderColor = AppColors.sidebarBorder.withValues(alpha: 0.65);
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFE6F1F6), Color(0xFFF7FBFD)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(36),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A2B3034),
          blurRadius: 24,
          offset: Offset(0, 18),
        ),
      ],
    );
  }

  static BoxDecoration sectionCard() {
    final Color borderColor = AppColors.sidebarBorder.withValues(alpha: 0.7);
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x112B3034),
          blurRadius: 18,
          offset: Offset(0, 12),
        ),
      ],
    );
  }

  static InputBorder inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.sidebarBorder),
    );
  }
}
