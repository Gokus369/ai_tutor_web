import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

import '../../domain/models/syllabus_subject.dart';

class SyllabusStatusChip extends StatelessWidget {
  const SyllabusStatusChip({super.key, required this.status});

  final SyllabusStatus status;

  @override
  Widget build(BuildContext context) {
    final Color background;
    switch (status) {
      case SyllabusStatus.inProgress:
        background = AppColors.syllabusStatusInProgress;
        break;
      case SyllabusStatus.completed:
        background = AppColors.syllabusStatusCompleted;
        break;
    }

    final String label = switch (status) {
      SyllabusStatus.inProgress => 'Inprogress',
      SyllabusStatus.completed => 'Completed',
    };

    return Container(
      height: 27,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTypography.syllabusStatusChip,
      ),
    );
  }
}
