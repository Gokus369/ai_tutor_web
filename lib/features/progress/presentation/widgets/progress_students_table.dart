import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ProgressStudentsTable extends StatelessWidget {
  const ProgressStudentsTable({
    super.key,
    required this.students,
    required this.compact,
  });

  final List<StudentProgress> students;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ProgressStyles.elevatedCard(),
      padding: EdgeInsets.all(compact ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students',
            style: AppTypography.sectionTitle.copyWith(fontSize: compact ? 20 : 22),
          ),
          const SizedBox(height: 14),
          _StudentsHeader(compact: compact),
          const SizedBox(height: 4),
          for (int i = 0; i < students.length; i++)
            _StudentRow(
              student: students[i],
              compact: compact,
              last: i == students.length - 1,
            ),
        ],
      ),
    );
  }
}

class _StudentsHeader extends StatelessWidget {
  const _StudentsHeader({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22),
      decoration: BoxDecoration(
        color: AppColors.progressSectionBackground,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Name',
              style: AppTypography.metricLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const ProgressHeaderDivider(),
          Expanded(
            flex: 3,
            child: Text(
              'Progress %',
              style: AppTypography.metricLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const ProgressHeaderDivider(),
          Expanded(
            flex: 3,
            child: Text(
              'Alert',
              style: AppTypography.metricLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.student,
    required this.compact,
    required this.last,
  });

  final StudentProgress student;
  final bool compact;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  student.name,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const ProgressRowDivider(),
              Expanded(
                flex: 3,
                child: _ProgressCell(value: student.progress, compact: compact),
              ),
              const ProgressRowDivider(),
              Expanded(
                flex: 3,
                child: _AlertCell(alert: student.alert),
              ),
              SizedBox(
                width: 38,
                child: IconButton(
                  onPressed: () {},
                  splashRadius: 18,
                  icon: const Icon(Icons.more_horiz, size: 20),
                ),
              ),
            ],
          ),
        ),
        if (!last)
          Divider(
            height: 1,
            thickness: 1,
            indent: compact ? 16 : 22,
            endIndent: compact ? 16 : 22,
            color: AppColors.progressSectionBorder.withValues(alpha: 0.55),
          ),
      ],
    );
  }
}

class _ProgressCell extends StatelessWidget {
  const _ProgressCell({required this.value, required this.compact});

  final double value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double ratio = value.clamp(0.0, 1.0);
    final String percentage = '${(ratio * 100).round()}%';

    return Row(
      children: [
        Expanded(
          child: Container(
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: AppColors.progressMetricTrack,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          percentage,
          style: AppTypography.metricLabel.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _AlertCell extends StatelessWidget {
  const _AlertCell({this.alert});

  final StudentAlert? alert;

  @override
  Widget build(BuildContext context) {
    if (alert == null) {
      return Text(
        '-',
        style: AppTypography.bodySmall.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.greyMuted,
        ),
      );
    }

    final Color color = alert!.type == StudentAlertType.warning
        ? AppColors.statusPendingBackground
        : AppColors.statusErrorBackground;

    return Text(
      alert!.label,
      style: AppTypography.bodySmall.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class ProgressHeaderDivider extends StatelessWidget {
  const ProgressHeaderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: AppColors.progressSectionBorder.withValues(alpha: 0.6),
    );
  }
}

class ProgressRowDivider extends StatelessWidget {
  const ProgressRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: AppColors.progressSectionBorder.withValues(alpha: 0.4),
    );
  }
}
