import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 128.52,
          height: 29.06,
          child: Center(
            child: Text(
              'AiTutor',
              style: AppTypography.brandWordmark,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 195,
          height: 27,
          child: Center(
            child: Text(
              'Create your Account',
              textAlign: TextAlign.center,
              style: AppTypography.signupTitle,
            ),
          ),
        ),
      ],
    );
  }
}
