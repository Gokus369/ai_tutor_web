import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/app_data_table.dart';
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
    final headerPadding = EdgeInsets.symmetric(horizontal: compact ? 16 : 22);
    final rowPadding = EdgeInsets.symmetric(
      horizontal: compact ? 16 : 22,
      vertical: compact ? 12 : 14,
    );

    return Container(
      decoration: ProgressStyles.elevatedCard(),
      padding: EdgeInsets.all(compact ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students',
            style: AppTypography.sectionTitle.copyWith(
              fontSize: compact ? 20 : 22,
            ),
          ),
          const SizedBox(height: 14),
          AppDataTable(
            columns: const [
              AppTableColumn(label: 'Name', flex: 4),
              AppTableColumn(label: 'Progress %', flex: 3),
              AppTableColumn(label: 'Alert', flex: 3),
            ],
            rows: students
                .map(
                  (student) => AppTableRowData(
                    cells: [
                      Text(
                        student.name,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      _ProgressCell(value: student.progress, compact: compact),
                      _AlertCell(alert: student.alert),
                    ],
                    trailing: IconButton(
                      onPressed: () {},
                      splashRadius: 18,
                      icon: const Icon(Icons.more_horiz, size: 20),
                    ),
                  ),
                )
                .toList(),
            compact: compact,
            headerPadding: headerPadding,
            rowPadding: rowPadding,
            columnSpacing: 18,
            trailingWidth: 38,
          ),
        ],
      ),
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
