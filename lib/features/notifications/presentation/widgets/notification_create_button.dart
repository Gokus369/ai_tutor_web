import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class NotificationCreateButton extends StatelessWidget {
  const NotificationCreateButton({
    super.key,
    required this.onPressed,
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final VoidCallback onPressed;
  final EdgeInsetsGeometry horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 20),
      label: Text(
        'Create Notifications',
        style: AppTypography.button,
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: horizontalPadding,
        minimumSize: const Size(0, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
