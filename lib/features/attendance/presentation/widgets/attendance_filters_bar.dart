import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/app_dropdown_field.dart';
import 'package:ai_tutor_web/shared/widgets/filter_panel.dart';
import 'package:flutter/material.dart';

class AttendanceFiltersBar extends StatelessWidget {
  const AttendanceFiltersBar({
    super.key,
    required this.searchController,
    required this.dateController,
    required this.classOptions,
    required this.subjectOptions,
    required this.selectedClass,
    required this.selectedSubject,
    required this.onClassChanged,
    required this.onSubjectChanged,
    required this.onPickDate,
    this.onSearchChanged,
  });

  final TextEditingController searchController;
  final TextEditingController dateController;
  final List<String> classOptions;
  final List<String> subjectOptions;
  final String selectedClass;
  final String selectedSubject;
  final ValueChanged<String> onClassChanged;
  final ValueChanged<String> onSubjectChanged;
  final VoidCallback onPickDate;
  final ValueChanged<String>? onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return FilterPanel(
      breakpoint: 860,
      children: [
        _SearchField(
          controller: searchController,
          onChanged: onSearchChanged,
        ),
        AppDropdownField<String>(
          label: 'Class',
          items: classOptions,
          value: selectedClass,
          onChanged: (value) {
            if (value != null) onClassChanged(value);
          },
          width: 160,
        ),
        AppDropdownField<String>(
          label: 'Subject',
          items: subjectOptions,
          value: selectedSubject,
          onChanged: (value) {
            if (value != null) onSubjectChanged(value);
          },
          width: 160,
        ),
        _DateField(
          controller: dateController,
          onTap: onPickDate,
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTypography.classCardMeta.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: _filterDecoration(
          hint: 'Search students',
          leadingIcon: Icons.search,
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.controller, required this.onTap});

  final TextEditingController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date',
            style: AppTypography.classCardMeta.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: true,
            showCursor: false,
            style: AppTypography.classCardMeta.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: _filterDecoration(
              hint: 'Date',
              trailingIcon: Icons.calendar_today_outlined,
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

InputDecoration _filterDecoration({
  required String hint,
  IconData? leadingIcon,
  IconData? trailingIcon,
}) {
  return InputDecoration(
    hintText: hint,
    isDense: true,
    prefixIcon: leadingIcon != null
        ? Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(leadingIcon, size: 18, color: AppColors.iconMuted),
          )
        : null,
    prefixIconConstraints: const BoxConstraints(minWidth: 32, maxHeight: 24),
    suffixIcon: trailingIcon != null
        ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(trailingIcon, size: 18, color: AppColors.iconMuted),
          )
        : null,
    suffixIconConstraints: const BoxConstraints(minWidth: 24, maxHeight: 24),
    filled: true,
    fillColor: AppColors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.studentsFilterBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.studentsFilterBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    hintStyle: AppTypography.classCardMeta.copyWith(
      color: AppColors.textMuted,
      fontWeight: FontWeight.w600,
    ),
  );
}
