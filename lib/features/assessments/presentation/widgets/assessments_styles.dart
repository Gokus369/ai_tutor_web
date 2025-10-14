import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AssessmentsStyles {
  AssessmentsStyles._();

  static BoxDecoration cardDecoration({double radius = 28}) => BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.progressCardBorder, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 32,
          ),
        ],
      );

  static EdgeInsets sectionPadding(bool compact) => EdgeInsets.all(compact ? 18 : 24);
}
