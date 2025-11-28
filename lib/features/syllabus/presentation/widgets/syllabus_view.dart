import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_progress.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_subject.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_progress_panel.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_subject_card.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SyllabusView extends StatelessWidget {
  const SyllabusView({
    super.key,
    required this.subjects,
    required this.progressEntries,
    required this.expandedIndex,
    required this.onSubjectToggle,
  });

  final List<SyllabusSubject> subjects;
  final List<SyllabusProgress> progressEntries;
  final int expandedIndex;
  final ValueChanged<int> onSubjectToggle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool showSidePanel = width >= 1080;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (width >= 720)
              Row(
                children: const [
                  Expanded(flex: 3, child: _SearchField()),
                  SizedBox(width: 20),
                  SizedBox(width: 163, height: 48, child: _AddSubjectButton()),
                ],
              )
            else ...const [
              _SearchField(),
              SizedBox(height: 12),
              SizedBox(width: double.infinity, height: 48, child: _AddSubjectButton()),
            ],
            const SizedBox(height: 18),
            if (width >= 720)
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(width: 200, height: 44, child: _ClassSelector()),
              )
            else
              const SizedBox(width: double.infinity, height: 44, child: _ClassSelector()),
            const SizedBox(height: 28),
            if (showSidePanel)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < subjects.length; i++) ...[
                          SyllabusSubjectCard(
                            subject: subjects[i],
                            expanded: i == expandedIndex,
                            onToggle: () => onSubjectToggle(i),
                          ),
                          if (i != subjects.length - 1) const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  SizedBox(
                    width: 360,
                    child: SyllabusProgressPanel(entries: progressEntries),
                  ),
                ],
              )
            else ...[
              Column(
                children: [
                  for (int i = 0; i < subjects.length; i++) ...[
                    SyllabusSubjectCard(
                      subject: subjects[i],
                      expanded: i == expandedIndex,
                      onToggle: () => onSubjectToggle(i),
                    ),
                    if (i != subjects.length - 1) const SizedBox(height: 20),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              SyllabusProgressPanel(entries: progressEntries),
            ],
          ],
        );
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by subjects, chapter or topic...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: AppColors.syllabusSearchBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _AddSubjectButton extends StatelessWidget {
  const _AddSubjectButton();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: AppTypography.button,
      ),
      child: const Text('+ Add Subject'),
    );
  }
}

class _ClassSelector extends StatefulWidget {
  const _ClassSelector();
  @override
  State<_ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<_ClassSelector> {
  String _value = 'Class 10';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.syllabusBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.syllabusSearchBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: _value,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
            style: AppTypography.classCardMeta,
            isExpanded: true,
            onChanged: (value) => setState(() => _value = value ?? _value),
            items: const [
              DropdownMenuItem(value: 'Class 10', child: Text('Class 10')),
              DropdownMenuItem(value: 'Class 11', child: Text('Class 11')),
              DropdownMenuItem(value: 'Class 12', child: Text('Class 12')),
            ],
          ),
        ),
      ),
    );
  }
}
