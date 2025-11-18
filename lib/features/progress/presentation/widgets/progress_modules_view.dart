import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/status_chip.dart';
import 'package:flutter/material.dart';

class ProgressModulesView extends StatelessWidget {
  const ProgressModulesView({
    super.key,
    required this.detail,
    required this.additionalSubjects,
    required this.compact,
  });

  final SubjectDetail detail;
  final List<SubjectSummary> additionalSubjects;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MathematicsCard(detail: detail, compact: compact),
        const SizedBox(height: 24),
        _AdditionalSubjectsCard(subjects: additionalSubjects, compact: compact),
      ],
    );
  }
}

class _MathematicsCard extends StatelessWidget {
  const _MathematicsCard({required this.detail, required this.compact});

  final SubjectDetail detail;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final chapters = detail.chapters;

    return Container(
      decoration: ProgressStyles.elevatedCard(),
      padding: EdgeInsets.fromLTRB(
        compact ? 22 : 28,
        compact ? 24 : 28,
        compact ? 22 : 28,
        compact ? 28 : 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      detail.name,
                      style: AppTypography.sectionTitle.copyWith(
                        fontSize: compact ? 22 : 24,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    _StatusChip(status: detail.status),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                splashRadius: 20,
                icon: const Icon(Icons.keyboard_arrow_up, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            detail.focusArea,
            style: AppTypography.metricLabel.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          for (int i = 0; i < chapters.length; i++) ...[
            _ChapterTile(progress: chapters[i]),
            if (i < chapters.length - 1) const SizedBox(height: 18),
          ],
          const SizedBox(height: 22),
          for (int i = 0; i < detail.collapsedModules.length; i++) ...[
            _CollapsedModuleTile(
              title: detail.collapsedModules[i],
              compact: compact,
            ),
            if (i < detail.collapsedModules.length - 1)
              const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _AdditionalSubjectsCard extends StatelessWidget {
  const _AdditionalSubjectsCard({
    required this.subjects,
    required this.compact,
  });

  final List<SubjectSummary> subjects;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ProgressStyles.elevatedCard(),
      padding: EdgeInsets.fromLTRB(
        compact ? 20 : 28,
        compact ? 20 : 28,
        compact ? 20 : 28,
        compact ? 24 : 28,
      ),
      child: Column(
        children: [
          for (int i = 0; i < subjects.length; i++) ...[
            _SubjectSummaryRow(summary: subjects[i], compact: compact),
            if (i < subjects.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({required this.progress});

  final ChapterProgress progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 70),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.progressModuleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  progress.title,
                  style: AppTypography.metricLabel.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                progress.progressLabel,
                style: AppTypography.metricLabel.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                splashRadius: 18,
                icon: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double filled = constraints.maxWidth * progress.progress;
              return Stack(
                children: [
                  Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.progressMetricTrack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: filled,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CollapsedModuleTile extends StatelessWidget {
  const _CollapsedModuleTile({required this.title, required this.compact});

  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.progressSectionBorder, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.metricLabel.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
        ],
      ),
    );
  }
}

class _SubjectSummaryRow extends StatelessWidget {
  const _SubjectSummaryRow({required this.summary, required this.compact});

  final SubjectSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 84 : 90,
      padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.progressSectionBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              summary.name,
              style: AppTypography.sectionTitle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          _StatusChip(status: summary.status),
          const SizedBox(width: 18),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final SubjectStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;
    late final String label;

    switch (status) {
      case SubjectStatus.inProgress:
        background = AppColors.syllabusStatusInProgress;
        foreground = AppColors.syllabusStatusText;
        label = 'Inprogress';
        break;
      case SubjectStatus.completed:
        background = AppColors.statusCompletedBackground;
        foreground = AppColors.statusCompletedText;
        label = 'Completed';
        break;
    }

    return AppStatusChip(
      label: label,
      backgroundColor: background,
      textColor: foreground,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 27,
      textStyle: AppTypography.statusChip(foreground),
    );
  }
}
