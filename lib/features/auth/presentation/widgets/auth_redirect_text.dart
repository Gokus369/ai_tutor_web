import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AuthRedirectText extends StatelessWidget {
  const AuthRedirectText({
    super.key,
    required this.prompt,
    required this.actionLabel,
    this.onTap,
    this.fontSize = 14,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback? onTap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            prompt,
            style: AppTypography.bodySmall.copyWith(fontSize: fontSize),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionLabel,
              style: AppTypography.linkSmall.copyWith(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
