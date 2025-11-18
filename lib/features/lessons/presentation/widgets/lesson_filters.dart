import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/widgets/app_dropdown_field.dart';
import 'package:ai_tutor_web/shared/widgets/filter_panel.dart';
import 'package:flutter/material.dart';

class LessonsFilters extends StatelessWidget {
  const LessonsFilters({
    super.key,
    required this.isCompact,
    required this.isTablet,
    required this.classOptions,
    required this.subjectOptions,
    required this.selectedClass,
    required this.selectedSubject,
    required this.searchController,
    required this.onClassChanged,
    required this.onSubjectChanged,
  });

  final bool isCompact;
  final bool isTablet;
  final List<String> classOptions;
  final List<String> subjectOptions;
  final String selectedClass;
  final String selectedSubject;
  final TextEditingController searchController;
  final ValueChanged<String> onClassChanged;
  final ValueChanged<String> onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    final dropdownWidth = isTablet ? 180.0 : 200.0;
    final searchWidth = isTablet ? 320.0 : 360.0;

    return FilterPanel(
      forceColumn: isCompact ? true : null,
      breakpoint: isTablet ? 920 : 1024,
      children: [
        SizedBox(
          width: searchWidth,
          child: _SearchField(controller: searchController),
        ),
        AppDropdownField<String>(
          label: 'Class',
          items: classOptions,
          value: selectedClass,
          onChanged: (value) {
            if (value != null) onClassChanged(value);
          },
          width: dropdownWidth,
        ),
        AppDropdownField<String>(
          label: 'Subject',
          items: subjectOptions,
          value: selectedSubject,
          onChanged: (value) {
            if (value != null) onSubjectChanged(value);
          },
          width: dropdownWidth,
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
          hintText: 'Search by subjects or topic...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: AppColors.syllabusSearchBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder),
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
