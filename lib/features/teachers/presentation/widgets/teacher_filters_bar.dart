import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class TeacherFiltersBar extends StatelessWidget {
  const TeacherFiltersBar({
    super.key,
    required this.isCompact,
    required this.schoolOptions,
    required this.subjectOptions,
    required this.attendanceOptions,
    required this.selectedSchool,
    required this.selectedSubject,
    required this.selectedAttendance,
    required this.searchController,
    required this.onSchoolChanged,
    required this.onSubjectChanged,
    required this.onAttendanceChanged,
  });

  final bool isCompact;
  final List<String> schoolOptions;
  final List<String> subjectOptions;
  final List<String> attendanceOptions;
  final String selectedSchool;
  final String selectedSubject;
  final String selectedAttendance;
  final TextEditingController searchController;
  final ValueChanged<String> onSchoolChanged;
  final ValueChanged<String> onSubjectChanged;
  final ValueChanged<String> onAttendanceChanged;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchField(controller: searchController),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: double.infinity,
                child: _FilterDropdown(
                  label: 'School',
                  value: selectedSchool,
                  items: schoolOptions,
                  onChanged: onSchoolChanged,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: _FilterDropdown(
                  label: 'Subject',
                  value: selectedSubject,
                  items: subjectOptions,
                  onChanged: onSubjectChanged,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: _FilterDropdown(
                  label: 'Attendance',
                  value: selectedAttendance,
                  items: attendanceOptions,
                  onChanged: onAttendanceChanged,
                ),
              ),
            ],
          ),
        ],
      );
    }

    const double gap = 12;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(flex: 2, child: _SearchField(controller: searchController)),
        const SizedBox(width: gap),
        Expanded(
          child: _FilterDropdown(
            label: 'School',
            value: selectedSchool,
            items: schoolOptions,
            onChanged: onSchoolChanged,
          ),
        ),
        const SizedBox(width: gap),
        Expanded(
          child: _FilterDropdown(
            label: 'Subject',
            value: selectedSubject,
            items: subjectOptions,
            onChanged: onSubjectChanged,
          ),
        ),
        const SizedBox(width: gap),
        Expanded(
          child: _FilterDropdown(
            label: 'Attendance',
            value: selectedAttendance,
            items: attendanceOptions,
            onChanged: onAttendanceChanged,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search teachers by name, email, subject, school...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: AppColors.studentsSearchBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.studentsSearchBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.studentsSearchBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.classCardMeta.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.studentsFilterBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.studentsFilterBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textPrimary,
                ),
                style: AppTypography.classCardMeta,
                onChanged: (val) {
                  if (val == null) return;
                  onChanged(val);
                },
                items: items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
