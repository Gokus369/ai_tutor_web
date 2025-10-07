import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.formLabel);
  }
}
