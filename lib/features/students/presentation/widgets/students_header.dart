import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class StudentsHeader extends StatelessWidget {
  const StudentsHeader({super.key, required this.isCompact, required this.onAddStudent});

  final bool isCompact;
  final VoidCallback onAddStudent;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Students', style: AppTypography.dashboardTitle),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onAddStudent,
              child: const Text('+ Add Student'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text('Students', style: AppTypography.dashboardTitle),
        ),
        SizedBox(
          width: 156,
          height: 48,
          child: ElevatedButton(
            onPressed: onAddStudent,
            child: const Text('+ Add Student'),
          ),
        ),
      ],
    );
  }
}
