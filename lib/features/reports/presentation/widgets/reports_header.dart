import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ReportsHeader extends StatelessWidget {
  const ReportsHeader({
    super.key,
    required this.data,
    required this.selectedClass,
    required this.onClassChanged,
    required this.onExportPressed,
    required this.narrow,
  });

  final ReportsData data;
  final String selectedClass;
  final ValueChanged<String> onClassChanged;
  final VoidCallback onExportPressed;
  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final dropdown = ReportsClassSelector(
      classes: data.classOptions,
      value: selectedClass,
      onChanged: onClassChanged,
    );

    final exportButton = SizedBox(
      width: 147,
      height: 50,
      child: FilledButton(
        onPressed: onExportPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.button.copyWith(fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: const Text('Export Report'),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports', style: AppTypography.dashboardTitle),
          const SizedBox(height: 18),
          dropdown,
          const SizedBox(height: 12),
          exportButton,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text('Reports', style: AppTypography.dashboardTitle)),
        dropdown,
        const SizedBox(width: 16),
        exportButton,
      ],
    );
  }
}

class ReportsClassSelector extends StatelessWidget {
  const ReportsClassSelector({
    super.key,
    required this.classes,
    required this.value,
    required this.onChanged,
  });

  final List<String> classes;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.sidebarBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.sidebarBorder),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.iconMuted),
            isExpanded: true,
            onChanged: (selected) {
              if (selected == null) return;
              onChanged(selected);
            },
            items: classes
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
