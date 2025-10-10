import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.studentsFilterBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.studentsFilterBorder, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double searchWidth = 367;
          const double dropdownWidth = 151;
          const double totalDropdownWidth = dropdownWidth * 3 + 16 * 2;
          final bool stackFilters =
              constraints.maxWidth < searchWidth + totalDropdownWidth + 40;

          Widget buildSearch(double width) {
            return SizedBox(
              width: width,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: AppTypography.classCardMeta.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: _decoration(
                  hint: 'Search students',
                  leadingIcon: Icons.search,
                ),
              ),
            );
          }

          Widget buildDropdown({
            required String value,
            required List<String> options,
            required ValueChanged<String> onChanged,
            required String hint,
          }) {
            return SizedBox(
              width: dropdownWidth,
              child: DropdownButtonFormField<String>(
                value: value,
                isExpanded: true,
                decoration: _decoration(hint: hint),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textPrimary,
                ),
                style: AppTypography.classCardMeta.copyWith(
                  color: AppColors.textPrimary,
                ),
                items: options
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option, style: AppTypography.classCardMeta),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  onChanged(value);
                },
              ),
            );
          }

          Widget buildDateField(double width) {
            return SizedBox(
              width: width,
              child: TextField(
                controller: dateController,
                readOnly: true,
                showCursor: false,
                style: AppTypography.classCardMeta.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: _decoration(
                  hint: 'Date',
                  trailingIcon: Icons.calendar_today_outlined,
                ),
                onTap: onPickDate,
              ),
            );
          }

          if (stackFilters) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSearch(constraints.maxWidth),
                const SizedBox(height: 16),
                buildDropdown(
                  value: selectedClass,
                  options: classOptions,
                  hint: 'Class',
                  onChanged: onClassChanged,
                ),
                const SizedBox(height: 16),
                buildDropdown(
                  value: selectedSubject,
                  options: subjectOptions,
                  hint: 'Subject',
                  onChanged: onSubjectChanged,
                ),
                const SizedBox(height: 16),
                buildDateField(constraints.maxWidth),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildSearch(searchWidth),
              const Spacer(),
              buildDropdown(
                value: selectedClass,
                options: classOptions,
                hint: 'Class',
                onChanged: onClassChanged,
              ),
              const SizedBox(width: 16),
              buildDropdown(
                value: selectedSubject,
                options: subjectOptions,
                hint: 'Subject',
                onChanged: onSubjectChanged,
              ),
              const SizedBox(width: 16),
              buildDateField(dropdownWidth),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _decoration({
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
}
