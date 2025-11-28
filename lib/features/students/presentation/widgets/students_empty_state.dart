import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class StudentsEmptyState extends StatelessWidget {
  const StudentsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Text(
        'No students match your filters. Try adjusting search or filters.',
        style: AppTypography.classCardMeta,
      ),
    );
  }
}
