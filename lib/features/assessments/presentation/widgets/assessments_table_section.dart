import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

/// Adaptive table that switches between a traditional grid and compact cards.
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
      key: ValueKey('assessments-table-${compact ? 'compact' : 'wide'}'),
      decoration: AssessmentsStyles.cardDecoration(),
      padding: AssessmentsStyles.sectionPadding(compact),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.sectionTitle.copyWith(fontSize: compact ? 20 : 22)),
          const SizedBox(height: 16),
          if (compact)
            _CompactRecordsList(
              key: const ValueKey('assessments-compact-records'),
              section: section,
            )
          else
            _WideRecordsTable(
              key: const ValueKey('assessments-wide-records'),
              section: section,
            ),
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
    super.key,
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

class _CompactRecordCard extends StatelessWidget {
  const _CompactRecordCard({super.key, required this.record, required this.showSubmitted});

  final AssessmentRecord record;
  final bool showSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.progressSectionBorder.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  record.title,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _StatusChip(status: record.status),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                splashRadius: 18,
                icon: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _CompactInfoRow(label: 'Subject', value: record.subject),
          _CompactInfoRow(label: 'Due Date', value: record.dueDateLabel),
          _CompactInfoRow(label: 'Class', value: record.className),
          if (showSubmitted) _CompactInfoRow(label: 'Submitted', value: record.submittedBy ?? '-'),
          if (record.scoreLabel != null) _CompactInfoRow(label: 'Score', value: record.scoreLabel!),
        ],
      ),
    );
  }
}

class _CompactInfoRow extends StatelessWidget {
  const _CompactInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.greyMuted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WideRecordsTable extends StatelessWidget {
  const _WideRecordsTable({super.key, required this.section});

  final AssessmentSectionData section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(columns: section.columns, compact: false),
        const SizedBox(height: 6),
        for (int i = 0; i < section.records.length; i++)
          _Row(
            key: ValueKey('assessments-row-${section.records[i].title}'),
            record: section.records[i],
            columns: section.columns,
            compact: false,
            last: i == section.records.length - 1,
          ),
      ],
    );
  }
}

class _CompactRecordsList extends StatelessWidget {
  const _CompactRecordsList({super.key, required this.section});

  final AssessmentSectionData section;

  @override
  Widget build(BuildContext context) {
    final bool showSubmitted = section.columns.contains('Submitted By');
    return Column(
      children: [
        for (final record in section.records)
          _CompactRecordCard(
            key: ValueKey('assessments-compact-card-${record.title}'),
            record: record,
            showSubmitted: showSubmitted,
          ),
      ],
    );
  }
}
