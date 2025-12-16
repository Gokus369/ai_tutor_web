import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final List<AddTeacherRequest> _teachers = [];

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.teachers,
      title: 'Teachers',
      builder: (context, shell) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage teachers',
                  style: AppTypography.sectionTitle,
                ),
                ElevatedButton.icon(
                  onPressed: _openAddTeacherDialog,
                  icon: const Icon(Icons.person_add_alt_1_outlined),
                  label: const Text('Add Teacher'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: _teachers.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No teachers yet. Add your first teacher to get started.',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _openAddTeacherDialog,
                          icon: const Icon(Icons.person_add_alt_1_outlined),
                          label: const Text('Add Teacher'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _teachers.length,
                      separatorBuilder: (_, __) => const Divider(height: 16),
                      itemBuilder: (context, index) {
                        final teacher = _teachers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                            foregroundColor: AppColors.primary,
                            child: Text(
                              teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : '?',
                            ),
                          ),
                          title: Text(teacher.name, style: AppTypography.bodyLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(teacher.email),
                              if (teacher.phone != null && teacher.phone!.isNotEmpty)
                                Text(teacher.phone!),
                              if (teacher.subject != null && teacher.subject!.isNotEmpty)
                                Text('Subject: ${teacher.subject}'),
                            ],
                          ),
                          trailing: IconButton(
                            tooltip: 'Remove',
                            icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
                            onPressed: () => setState(() => _teachers.removeAt(index)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAddTeacherDialog() async {
    final result = await showDialog<AddTeacherRequest>(
      context: context,
      builder: (_) => const AddTeacherDialog(),
    );
    if (result == null || !mounted) return;
    setState(() => _teachers.add(result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Teacher "${result.name}" added')),
    );
  }
}
