import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AssessmentsSummaryCard extends StatelessWidget {
  const AssessmentsSummaryCard({
    super.key,
    required this.filters,
    required this.activeView,
    required this.onViewChanged,
    required this.onClassChanged,
    required this.onStatusChanged,
    required this.onSubjectChanged,
    required this.searchController,
    required this.onSearchChanged,
  });

  final AssessmentFilterOptions filters;
  final AssessmentView activeView;
  final ValueChanged<AssessmentView> onViewChanged;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onSubjectChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AssessmentsStyles.cardDecoration(),
      padding: AssessmentsStyles.sectionPadding(false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Assessments', style: AppTypography.sectionTitle.copyWith(fontSize: 24)),
              ),
              SizedBox(
                width: 151,
                child: _Dropdown(
                  initialValue: filters.initialClass,
                  options: filters.classOptions,
                  onChanged: onClassChanged,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 50,
                child: FilledButton.icon(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: AppTypography.button,
                  ),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Create Assessment'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    key: const ValueKey('assessments-search'),
                    controller: searchController,
                    onChanged: onSearchChanged,
                    enabled: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                      hintText: 'Search assessments, quizzes and exams…',
                      hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.greyMuted),
                      filled: true,
                      fillColor: AppColors.syllabusSearchBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.sidebarBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: AppColors.sidebarBorder),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 151,
                child: _Dropdown(
                  initialValue: filters.initialStatus,
                  options: filters.statusOptions,
                  onChanged: onStatusChanged,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 151,
                child: _Dropdown(
                  initialValue: filters.initialSubject,
                  options: filters.subjectOptions,
                  onChanged: onSubjectChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _ViewChip(
                chipKey: const ValueKey('assessments-view-assignments'),
                label: 'Assignments',
                active: activeView == AssessmentView.assignments,
                onTap: () => onViewChanged(AssessmentView.assignments),
              ),
              const SizedBox(width: 12),
              _ViewChip(
                chipKey: const ValueKey('assessments-view-quizzes'),
                label: 'Quizzes',
                active: activeView == AssessmentView.quizzes,
                onTap: () => onViewChanged(AssessmentView.quizzes),
              ),
              const SizedBox(width: 12),
              _ViewChip(
                chipKey: const ValueKey('assessments-view-exams'),
                label: 'Exams',
                active: activeView == AssessmentView.exams,
                onTap: () => onViewChanged(AssessmentView.exams),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.initialValue, required this.options, required this.onChanged});

  final String initialValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: ValueKey(initialValue),
      initialValue: initialValue,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.syllabusSearchBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.sidebarBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.sidebarBorder),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
      items: options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _ViewChip extends StatelessWidget {
  const _ViewChip({required this.label, required this.active, required this.onTap, this.chipKey});

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Key? chipKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: chipKey,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.progressChipBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: active ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
