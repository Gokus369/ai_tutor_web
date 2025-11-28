import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/student_filters_bar.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/student_table.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/students_empty_state.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          StudentTable(students: students),
      ],
    );
  }
}
