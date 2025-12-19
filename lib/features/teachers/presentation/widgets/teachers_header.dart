import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class TeachersHeader extends StatelessWidget {
  const TeachersHeader({
    super.key,
    required this.isCompact,
    required this.onAddTeacher,
  });

  final bool isCompact;
  final VoidCallback onAddTeacher;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Teachers', style: AppTypography.dashboardTitle),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onAddTeacher,
              child: const Text('+ Add Teacher'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: Text('Teachers', style: AppTypography.dashboardTitle)),
        SizedBox(
          width: 156,
          height: 48,
          child: ElevatedButton(
            onPressed: onAddTeacher,
            child: const Text('+ Add Teacher'),
          ),
        ),
      ],
    );
  }
}
