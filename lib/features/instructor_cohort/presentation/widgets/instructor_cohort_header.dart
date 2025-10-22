import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class InstructorCohortHeader extends StatelessWidget {
  const InstructorCohortHeader({
    super.key,
    required this.title,
    required this.searchController,
    required this.classOptions,
    required this.topicOptions,
    required this.selectedClass,
    required this.selectedTopic,
    required this.onClassChanged,
    required this.onTopicChanged,
    required this.onDownloadReport,
    required this.isCompact,
  });

  final String title;
  final TextEditingController searchController;
  final List<String> classOptions;
  final List<String> topicOptions;
  final String selectedClass;
  final String selectedTopic;
  final ValueChanged<String> onClassChanged;
  final ValueChanged<String> onTopicChanged;
  final VoidCallback onDownloadReport;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final Widget downloadButton = ElevatedButton.icon(
      onPressed: onDownloadReport,
      icon: const Icon(Icons.save_alt_outlined, size: 18),
      label: Text('Download Report', style: AppTypography.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.dashboardTitle),
          const SizedBox(height: 16),
          _SearchField(controller: searchController),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  options: classOptions,
                  value: selectedClass,
                  onChanged: onClassChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DropdownField(
                  options: topicOptions,
                  value: selectedTopic,
                  onChanged: onTopicChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: downloadButton),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: AppTypography.dashboardTitle)),
            downloadButton,
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: _SearchField(controller: searchController),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 160,
              child: _DropdownField(
                options: classOptions,
                value: selectedClass,
                onChanged: onClassChanged,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 160,
              child: _DropdownField(
                options: topicOptions,
                value: selectedTopic,
                onChanged: onTopicChanged,
              ),
            ),
          ],
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
      height: 50,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search students by name...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.studentsCardBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.studentsCardBorder),
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

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.studentsCardBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconMuted,
          ),
          isExpanded: true,
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ),
    );
  }
}
