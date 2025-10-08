import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_subject.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_status_chip.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SyllabusSubjectCard extends StatelessWidget {
  const SyllabusSubjectCard({
    super.key,
    required this.subject,
    required this.expanded,
    required this.onToggle,
  });

  final SyllabusSubject subject;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.syllabusBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.syllabusCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Row(
                children: [
                  Text(subject.title, style: AppTypography.syllabusSectionHeading),
                  const SizedBox(width: 18),
                  SyllabusStatusChip(status: subject.status),
                  const Spacer(),
                  Icon(expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textPrimary, size: 26),
                ],
              ),
            ),
          ),
          if (expanded)
            const Divider(height: 1, color: AppColors.syllabusDivider),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 20),
              child: Column(
                children: [
                  _ModuleList(modules: subject.modules),
                  if (subject.additionalTopics.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    _TopicList(topics: subject.additionalTopics),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ModuleList extends StatelessWidget {
  const _ModuleList({required this.modules});

  final List<SyllabusModule> modules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < modules.length; i++) ...[
          _ModuleTile(module: modules[i]),
          if (i != modules.length - 1)
            const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module});

  final SyllabusModule module;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(module.title, style: AppTypography.syllabusModuleTitle),
            ),
            Text('${(module.completionPercentage * 100).round()}%', style: AppTypography.classProgressValue),
            const SizedBox(width: 8),
            const Icon(Icons.more_horiz, color: AppColors.greyMuted, size: 20),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.syllabusProgressTrack,
            borderRadius: BorderRadius.circular(8),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: module.completionPercentage.clamp(0, 1),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.syllabusProgressValue,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(module.topicSummary, style: AppTypography.syllabusModuleMeta),
      ],
    );
  }
}

class _TopicList extends StatelessWidget {
  const _TopicList({required this.topics});

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < topics.length; i++) ...[
          Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.syllabusCardBorder),
              color: AppColors.syllabusSectionBackground,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerLeft,
            child: Text(topics[i], style: AppTypography.syllabusModuleTitle),
          ),
          if (i != topics.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }
}
