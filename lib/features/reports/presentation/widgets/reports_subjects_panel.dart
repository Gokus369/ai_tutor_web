import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ReportsSubjectsPanel extends StatelessWidget {
  const ReportsSubjectsPanel({super.key, required this.subjects, required this.padding});

  final List<SubjectProgress> subjects;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE4F0F5), Color(0xFFF5FBFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.sidebarBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subject Progress', style: AppTypography.sectionTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 24),
          Column(
            children: [
              for (int i = 0; i < subjects.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                SubjectProgressTile(data: subjects[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class SubjectProgressTile extends StatelessWidget {
  const SubjectProgressTile({super.key, required this.data});

  final SubjectProgress data;

  @override
  Widget build(BuildContext context) {
    final double percentage = (data.progress.clamp(0, 1) * 100).roundToDouble();

    return Container(
      key: ValueKey('reports-subject-${data.subject}'),
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sidebarBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data.subject,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: LinearProgressIndicator(
                      value: data.progress.clamp(0, 1),
                      minHeight: 10,
                      backgroundColor: AppColors.searchFieldBorder.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${percentage.toInt()}%',
                    textAlign: TextAlign.right,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
