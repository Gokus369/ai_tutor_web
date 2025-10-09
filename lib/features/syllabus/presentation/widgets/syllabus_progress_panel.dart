import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_progress.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SyllabusProgressPanel extends StatelessWidget {
  const SyllabusProgressPanel({super.key, required this.entries});

  final List<SyllabusProgress> entries;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double horizontalPadding = constraints.maxWidth < 360 ? 20 : 28;
        return Container(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 24),
          decoration: BoxDecoration(
            color: AppColors.syllabusBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.syllabusCardBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Progress Overview', style: AppTypography.syllabusSectionHeading),
              const SizedBox(height: 20),
              for (int i = 0; i < entries.length; i++) ...[
                _ProgressTile(entry: entries[i]),
                if (i != entries.length - 1) const SizedBox(height: 18),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({required this.entry});

  final SyllabusProgress entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(entry.subject, style: AppTypography.syllabusModuleTitle)),
            Text('${(entry.completionPercentage * 100).round()}%', style: AppTypography.classProgressValue),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.syllabusProgressTrack,
            borderRadius: BorderRadius.circular(6),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: entry.completionPercentage.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.syllabusProgressValue,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
