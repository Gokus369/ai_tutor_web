import 'package:ai_tutor_web/features/instructor_cohort/domain/models/learner_progress.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ClassCompletionCard extends StatelessWidget {
  const ClassCompletionCard({
    super.key,
    required this.learners,
    this.isCompact = false,
  });

  final List<LearnerProgress> learners;
  final bool isCompact;

  static const double _cardWidth = 1138;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? double.infinity : _cardWidth,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Class Completion Progress', style: AppTypography.sectionTitle),
          const SizedBox(height: 20),
          Column(
            children: [
              for (int i = 0; i < learners.length; i++) ...[
                _LearnerRow(learner: learners[i]),
                if (i != learners.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _LearnerRow extends StatelessWidget {
  const _LearnerRow({required this.learner});

  final LearnerProgress learner;

  @override
  Widget build(BuildContext context) {
    final double percent = learner.completionPercent.clamp(0, 100) / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          learner.name,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 14,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.searchFieldBackground,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${learner.completionPercent.toStringAsFixed(0)}%',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
