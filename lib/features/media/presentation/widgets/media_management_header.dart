import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class MediaManagementHeader extends StatelessWidget {
  const MediaManagementHeader({
    super.key,
    required this.title,
    required this.classOptions,
    required this.selectedClass,
    required this.onClassChanged,
    required this.onUploadNew,
    required this.stacked,
  });

  final String title;
  final List<String> classOptions;
  final String selectedClass;
  final ValueChanged<String> onClassChanged;
  final VoidCallback onUploadNew;
  final bool stacked;

  DropdownButton<String> _buildDropdown() {
    return DropdownButton<String>(
      value: selectedClass,
      items: classOptions
          .map((option) => DropdownMenuItem(value: option, child: Text(option)))
          .toList(),
      onChanged: (value) {
        if (value != null) onClassChanged(value);
      },
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.iconMuted,
      ),
      underline: const SizedBox.shrink(),
      style: AppTypography.bodySmall.copyWith(
        fontSize: 15,
        color: AppColors.textPrimary,
      ),
    );
  }

  ElevatedButton _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: onUploadNew,
      icon: const Icon(Icons.upload_file_rounded, size: 18),
      label: Text('Upload New', style: AppTypography.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dropdownContainer = Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.studentsCardBorder),
      ),
      child: Center(child: _buildDropdown()),
    );

    final uploadButton = _buildUploadButton();

    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.dashboardTitle),
          const SizedBox(height: 16),
          dropdownContainer,
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: uploadButton),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: Text(title, style: AppTypography.dashboardTitle)),
        dropdownContainer,
        const SizedBox(width: 16),
        uploadButton,
      ],
    );
  }
}
