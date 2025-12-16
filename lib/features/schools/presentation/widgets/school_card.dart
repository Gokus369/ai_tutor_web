import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SchoolCard extends StatelessWidget {
  const SchoolCard({
    super.key,
    required this.school,
    required this.onEdit,
    required this.onDelete,
  });

  final School school;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.quickActionsContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.summaryCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  school.address ?? 'Address unavailable',
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _MetaChip(label: 'Code', value: school.code ?? '-'),
                    _MetaChip(label: 'Supplier ID', value: '${school.boardId ?? '-'}'),
                    if (school.createdById != null)
                      _MetaChip(
                        label: 'Linked restaurant',
                        value: '${school.createdById}',
                      ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.syllabusSectionBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: AppTypography.bodySmall),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
