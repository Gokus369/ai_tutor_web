import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_school_dialog.dart';
import 'package:ai_tutor_web/features/schools/presentation/widgets/school_card.dart';
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
                        return SchoolCard(
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
