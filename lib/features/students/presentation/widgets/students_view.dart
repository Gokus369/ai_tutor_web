import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/student_filters_bar.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/student_table.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/students_empty_state.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/section_card.dart';
import 'package:flutter/material.dart';

class StudentsView extends StatelessWidget {
  const StudentsView({
    super.key,
    required this.students,
    required this.classOptions,
    required this.attendanceOptions,
    required this.progressOptions,
    required this.performanceOptions,
    required this.selectedClass,
    required this.selectedAttendance,
    required this.selectedProgress,
    required this.selectedPerformance,
    required this.searchController,
    required this.onClassChanged,
    required this.onAttendanceChanged,
    required this.onProgressChanged,
    required this.onPerformanceChanged,
    required this.isCompactFilters,
    required this.currentPage,
    required this.totalPages,
    required this.showPagination,
    this.onPreviousPage,
    this.onNextPage,
  });

  final List<StudentReport> students;
  final List<String> classOptions;
  final List<String> attendanceOptions;
  final List<String> progressOptions;
  final List<String> performanceOptions;
  final String selectedClass;
  final String selectedAttendance;
  final String selectedProgress;
  final String selectedPerformance;
  final TextEditingController searchController;
  final ValueChanged<String> onClassChanged;
  final ValueChanged<String> onAttendanceChanged;
  final ValueChanged<String> onProgressChanged;
  final ValueChanged<String> onPerformanceChanged;
  final bool isCompactFilters;
  final int currentPage;
  final int totalPages;
  final bool showPagination;
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
          child: StudentFiltersBar(
            isCompact: isCompactFilters,
            classOptions: classOptions,
            attendanceOptions: attendanceOptions,
            progressOptions: progressOptions,
            performanceOptions: performanceOptions,
            selectedClass: selectedClass,
            selectedAttendance: selectedAttendance,
            selectedProgress: selectedProgress,
            selectedPerformance: selectedPerformance,
            searchController: searchController,
            onClassChanged: onClassChanged,
            onAttendanceChanged: onAttendanceChanged,
            onProgressChanged: onProgressChanged,
            onPerformanceChanged: onPerformanceChanged,
          ),
        ),
        const SizedBox(height: 24),
        if (students.isEmpty)
          const StudentsEmptyState()
        else
          SectionCard(
            title: 'Students',
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
                StudentTable(students: students),
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
