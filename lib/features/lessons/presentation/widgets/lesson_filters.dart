import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
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
    final dropdownSpacing = isTablet ? 16.0 : 20.0;

    final dropdowns = [
      Expanded(
        child: _DropdownFilter(
          label: 'Class',
          value: selectedClass,
          items: classOptions,
          onChanged: onClassChanged,
        ),
      ),
      SizedBox(width: dropdownSpacing),
      Expanded(
        child: _DropdownFilter(
          label: 'Subject',
          value: selectedSubject,
          items: subjectOptions,
          onChanged: onSubjectChanged,
        ),
      ),
    ];

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchField(controller: searchController),
          const SizedBox(height: 16),
          Row(children: dropdowns),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: isTablet ? 2 : 3,
          child: _SearchField(controller: searchController),
        ),
        SizedBox(width: dropdownSpacing),
        Flexible(
          flex: 1,
          child: _DropdownFilter(
            label: 'Class',
            value: selectedClass,
            items: classOptions,
            onChanged: onClassChanged,
          ),
        ),
        SizedBox(width: dropdownSpacing),
        Flexible(
          flex: 1,
          child: _DropdownFilter(
            label: 'Subject',
            value: selectedSubject,
            items: subjectOptions,
            onChanged: onSubjectChanged,
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

class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({
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
          style: AppTypography.classCardMeta.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.studentsFilterBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.studentsFilterBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                style: AppTypography.classCardMeta,
                onChanged: (val) {
                  if (val == null) return;
                  onChanged(val);
                },
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ),
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

