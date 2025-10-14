import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AssessmentsTableSection extends StatelessWidget {
  const AssessmentsTableSection({
    super.key,
    required this.title,
    required this.section,
    required this.compact,
  });

  final String title;
  final AssessmentSectionData section;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AssessmentsStyles.cardDecoration(),
      padding: AssessmentsStyles.sectionPadding(compact),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.sectionTitle.copyWith(fontSize: compact ? 20 : 22)),
          const SizedBox(height: 16),
          _Header(columns: section.columns, compact: compact),
          const SizedBox(height: 6),
          for (int i = 0; i < section.records.length; i++)
            _Row(record: section.records[i], columns: section.columns, compact: compact, last: i == section.records.length - 1),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.columns, required this.compact});

  final List<String> columns;
  final bool compact;

  List<int> get _flexes => columns.length == 5 ? const [4, 2, 2, 2, 2] : const [4, 2, 2, 2];

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
        children: [
          for (int i = 0; i < columns.length; i++) ...[
            Expanded(
              flex: _flexes[i],
              child: Text(
                columns[i],
                style: AppTypography.metricLabel.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (i < columns.length - 1) _DividerLine(compact: compact),
          ],
          const SizedBox(width: 38),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.record,
    required this.columns,
    required this.compact,
    required this.last,
  });

  final AssessmentRecord record;
  final List<String> columns;
  final bool compact;
  final bool last;

  List<int> get _flexes => columns.length == 5 ? const [4, 2, 2, 2, 2] : const [4, 2, 2, 2];

  @override
  Widget build(BuildContext context) {
    final bool showSubmitted = columns.contains('Submitted By');
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22, vertical: 14),
          child: Row(
            children: [
              Expanded(
                flex: _flexes[0],
                child: Text(
                  record.title,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _DividerLine(compact: compact),
              Expanded(
                flex: _flexes[1],
                child: Text(
                  record.subject,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _DividerLine(compact: compact),
              Expanded(
                flex: _flexes[2],
                child: Text(
                  record.dueDateLabel,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _DividerLine(compact: compact),
              Expanded(
                flex: _flexes[3],
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _StatusChip(status: record.status),
                ),
              ),
              if (showSubmitted) ...[
                _DividerLine(compact: compact),
                Expanded(
                  flex: _flexes[4],
                  child: Text(
                    record.submittedBy ?? '-',
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
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

class _DividerLine extends StatelessWidget {
  const _DividerLine({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: compact ? 24 : 28,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      color: AppColors.progressSectionBorder.withValues(alpha: 0.4),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final AssessmentStatus status;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor;
    final Color textColor;
    switch (status) {
      case AssessmentStatus.completed:
        backgroundColor = AppColors.statusCompletedBackground;
        textColor = AppColors.statusCompletedText;
        break;
      case AssessmentStatus.pending:
        backgroundColor = AppColors.statusPendingBackground;
        textColor = AppColors.statusPendingText;
        break;
      case AssessmentStatus.scheduled:
        backgroundColor = AppColors.statusScheduledBackground;
        textColor = AppColors.statusScheduledText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      constraints: const BoxConstraints(minHeight: 26),
      alignment: Alignment.center,
      child: Text(
        status.label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
