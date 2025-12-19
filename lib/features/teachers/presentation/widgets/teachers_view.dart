import 'package:ai_tutor_web/features/teachers/domain/models/teacher.dart';
import 'package:ai_tutor_web/features/teachers/presentation/widgets/teacher_filters_bar.dart';
import 'package:ai_tutor_web/features/teachers/presentation/widgets/teachers_table.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';

class TeachersView extends StatelessWidget {
  const TeachersView({
    super.key,
    required this.searchController,
    required this.teachers,
    required this.schoolOptions,
    required this.subjectOptions,
    required this.attendanceOptions,
    required this.selectedSchool,
    required this.selectedSubject,
    required this.selectedAttendance,
    required this.onSchoolChanged,
    required this.onSubjectChanged,
    required this.onAttendanceChanged,
    required this.onEditTeacher,
    required this.onRemoveTeacher,
    required this.isCompactFilters,
    required this.currentPage,
    required this.totalPages,
    required this.showPagination,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    this.onPreviousPage,
    this.onNextPage,
  });

  final TextEditingController searchController;
  final List<Teacher> teachers;
  final List<String> schoolOptions;
  final List<String> subjectOptions;
  final List<String> attendanceOptions;
  final String selectedSchool;
  final String selectedSubject;
  final String selectedAttendance;
  final ValueChanged<String> onSchoolChanged;
  final ValueChanged<String> onSubjectChanged;
  final ValueChanged<String> onAttendanceChanged;
  final ValueChanged<Teacher> onEditTeacher;
  final ValueChanged<Teacher> onRemoveTeacher;
  final bool isCompactFilters;
  final int currentPage;
  final int totalPages;
  final bool showPagination;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.studentsCardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: TeacherFiltersBar(
            isCompact: isCompactFilters,
            schoolOptions: schoolOptions,
            subjectOptions: subjectOptions,
            attendanceOptions: attendanceOptions,
            selectedSchool: selectedSchool,
            selectedSubject: selectedSubject,
            selectedAttendance: selectedAttendance,
            searchController: searchController,
            onSchoolChanged: onSchoolChanged,
            onSubjectChanged: onSubjectChanged,
            onAttendanceChanged: onAttendanceChanged,
          ),
        ),
        const SizedBox(height: 24),
        if (isLoading || error != null)
          SectionCard(
            title: 'Teachers',
            trailing: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.studentsFilterBorder),
                color: AppColors.studentsFilterBackground,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Text(
                  'All',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Could not load teachers',
                          style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentRed,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          error ?? 'Unknown error',
                          style: const TextStyle(color: AppColors.accentRed),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: onRetry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          )
        else if (teachers.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.studentsCardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.studentsCardBorder),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Text(
              'No teachers yet. Add your first teacher to get started.',
              style: AppTypography.bodySmall.copyWith(fontSize: 16),
            ),
          )
        else
          SectionCard(
            title: 'Teachers',
            trailing: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.studentsFilterBorder),
                color: AppColors.studentsFilterBackground,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Text(
                  'All',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TeachersTable(
                  teachers: teachers,
                  onEdit: onEditTeacher,
                  onRemove: onRemoveTeacher,
                ),
                if (showPagination) ...[
                  const SizedBox(height: 16),
                  _PaginationControls(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPrevious: onPreviousPage,
                    onNext: onNextPage,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    this.onPrevious,
    this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = AppTypography.bodySmall.copyWith(
      fontWeight: FontWeight.w700,
      color: AppColors.textPrimary,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Page $currentPage of $totalPages', style: labelStyle),
        Row(
          children: [
            _PaginationButton(
              label: 'Prev',
              icon: Icons.chevron_left_rounded,
              onPressed: onPrevious,
            ),
            const SizedBox(width: 8),
            _PaginationButton(
              label: 'Next',
              icon: Icons.chevron_right_rounded,
              onPressed: onNext,
            ),
          ],
        ),
      ],
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        disabledForegroundColor: AppColors.textMuted,
        side: const BorderSide(color: AppColors.studentsFilterBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
