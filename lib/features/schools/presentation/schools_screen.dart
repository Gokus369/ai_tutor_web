import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_school_dialog.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final List<AddSchoolRequest> _schools = [
    AddSchoolRequest(
      schoolName: 'Sunshine Public School',
      address: '456 Park Avenue, Mumbai, Maharashtra 400001',
      code: 'SPS001',
      boardId: 1,
      createdById: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.schools,
      title: 'Schools',
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Manage Schools', style: AppTypography.sectionTitle),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add School'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppTypography.button.copyWith(
                      fontSize: 15,
                      letterSpacing: 0.2,
                    ),
                    shadowColor: AppColors.primary.withValues(alpha: 0.35),
                  ),
                  onPressed: () => _openAddSchoolDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.summaryCardBorder),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 14,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Schools list', style: AppTypography.sectionTitle),
                  const SizedBox(height: 12),
                  if (_schools.isEmpty)
                    const Text(
                      'No schools added yet. Use "Add School" to create one.',
                      style: TextStyle(color: AppColors.textMuted),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _schools.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final school = _schools[index];
                        return _SchoolCard(
                          school: school,
                          onEdit: () => _openEditSchoolDialog(context, index, school),
                          onDelete: () => _removeSchool(index),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAddSchoolDialog(BuildContext context) async {
    final result = await showDialog<AddSchoolRequest>(
      context: context,
      builder: (_) => const AddSchoolDialog(),
    );
    if (result == null || !context.mounted) return;
    setState(() => _schools.add(result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('School "${result.schoolName}" added'),
      ),
    );
  }

  Future<void> _openEditSchoolDialog(
    BuildContext context,
    int index,
    AddSchoolRequest school,
  ) async {
    final result = await showDialog<AddSchoolRequest>(
      context: context,
      builder: (_) => AddSchoolDialog(
        initial: school,
        title: 'Edit School',
        confirmLabel: 'Save',
      ),
    );
    if (result == null || !context.mounted) return;
    setState(() => _schools[index] = result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('School "${result.schoolName}" updated'),
      ),
    );
  }

  void _removeSchool(int index) {
    final removed = _schools.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('School "${removed.schoolName}" removed'),
      ),
    );
  }
}

class _SchoolCard extends StatelessWidget {
  const _SchoolCard({
    required this.school,
    required this.onEdit,
    required this.onDelete,
  });

  final AddSchoolRequest school;
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
                  school.schoolName,
                  style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  school.address,
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 14,
                  runSpacing: 6,
                  children: [
                    _MetaChip(label: 'Code', value: school.code),
                    _MetaChip(label: 'Board ID', value: '${school.boardId}'),
                    if (school.createdById != null)
                      _MetaChip(
                        label: 'Created by',
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
