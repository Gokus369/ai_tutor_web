import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class StudentFiltersBar extends StatelessWidget {
  const StudentFiltersBar({
    super.key,
    required this.isCompact,
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
  });

  final bool isCompact;
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

  @override
  Widget build(BuildContext context) {
    final entries = [
      _FilterDropdown(
        label: 'Class',
        value: selectedClass,
        items: classOptions,
        onChanged: onClassChanged,
      ),
      _FilterDropdown(
        label: 'Attendance',
        value: selectedAttendance,
        items: attendanceOptions,
        onChanged: onAttendanceChanged,
      ),
      _FilterDropdown(
        label: 'Progress',
        value: selectedProgress,
        items: progressOptions,
        onChanged: onProgressChanged,
      ),
      _FilterDropdown(
        label: 'Performance',
        value: selectedPerformance,
        items: performanceOptions,
        onChanged: onPerformanceChanged,
      ),
    ];

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchField(controller: searchController),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: entries.map((dropdown) => SizedBox(width: double.infinity, child: dropdown)).toList(),
          ),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.start,
      children: [
        SizedBox(
          width: 360,
          child: _SearchField(controller: searchController),
        ),
        for (final dropdown in entries) SizedBox(width: 170, child: dropdown),
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
          hintText: 'Search students by name, class...',
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
        Text(label, style: AppTypography.classCardMeta.copyWith(fontWeight: FontWeight.w700)),
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
