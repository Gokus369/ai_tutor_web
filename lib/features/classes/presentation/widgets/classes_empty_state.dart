import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ClassesEmptyState extends StatelessWidget {
  const ClassesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Text(
        'No classes match your filters. Try adjusting the search or board.',
        style: AppTypography.classCardMeta,
      ),
    );
  }
}
