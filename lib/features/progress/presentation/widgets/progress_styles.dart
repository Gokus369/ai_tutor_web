import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressStyles {
  ProgressStyles._();

  static const double cardRadius = 28;
  static BoxDecoration elevatedCard({double radius = cardRadius}) {
    return BoxDecoration(
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
  }

}
