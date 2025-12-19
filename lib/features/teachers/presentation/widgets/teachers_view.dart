import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
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
    required this.selectedSchool,
    required this.selectedSubject,
    required this.onSchoolChanged,
    required this.onSubjectChanged,
    required this.onAddTeacher,
    required this.onRemoveTeacher,
  });

  final TextEditingController searchController;
  final List<AddTeacherRequest> teachers;
  final List<String> schoolOptions;
  final List<String> subjectOptions;
  final String selectedSchool;
  final String selectedSubject;
  final ValueChanged<String> onSchoolChanged;
  final ValueChanged<String> onSubjectChanged;
  final VoidCallback onAddTeacher;
  final ValueChanged<AddTeacherRequest> onRemoveTeacher;

  @override
  Widget build(BuildContext context) {
    final bool isCompactHeader = MediaQuery.of(context).size.width < 720;
    final bool isCompactFilters = MediaQuery.of(context).size.width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Teachers', style: AppTypography.dashboardTitle),
            ),
            SizedBox(
              width: 156,
              height: 48,
              child: ElevatedButton(
                onPressed: onAddTeacher,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('+ Add Teacher'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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
          padding: EdgeInsets.symmetric(
            horizontal: isCompactHeader ? 16 : 20,
            vertical: isCompactHeader ? 14 : 18,
          ),
          child: TeacherFiltersBar(
            isCompact: isCompactFilters,
            schoolOptions: schoolOptions,
            subjectOptions: subjectOptions,
            selectedSchool: selectedSchool,
            selectedSubject: selectedSubject,
            searchController: searchController,
            onSchoolChanged: onSchoolChanged,
            onSubjectChanged: onSubjectChanged,
          ),
        ),
        const SizedBox(height: 24),
        if (teachers.isEmpty)
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
            child: TeachersTable(teachers: teachers, onRemove: onRemoveTeacher),
          ),
      ],
    );
  }
}
