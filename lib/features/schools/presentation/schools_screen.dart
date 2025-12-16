import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_school_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/confirmation_dialog.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/features/schools/presentation/widgets/school_card.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  SchoolCubit get _cubit => context.read<SchoolCubit>();

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.schools,
      title: 'Suppliers',
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Manage Suppliers', style: AppTypography.sectionTitle),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Supplier'),
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
              child: BlocBuilder<SchoolCubit, SchoolState>(
                builder: (context, state) {
                  final loading = state.status == SchoolStatus.loading;
                  final error = state.error;
                  final schools = state.schools;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Supplier list', style: AppTypography.sectionTitle),
                      const SizedBox(height: 12),
                      if (loading)
                        const Center(child: CircularProgressIndicator())
                      else if (error != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Could not load suppliers',
                              style: AppTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentRed,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              error,
                              style: const TextStyle(color: AppColors.accentRed),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => _cubit.loadSchools(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (schools.isEmpty)
                        const Text(
                          'No suppliers found. Adjust filters and try again.',
                          style: TextStyle(color: AppColors.textMuted),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: schools.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final school = schools[index];
                            return SchoolCard(
                              school: school,
                              onEdit: () => _openEditSchoolDialog(context, school),
                              onDelete: () => _deleteSchool(context, school),
                            );
                          },
                        ),
                    ],
                  );
                },
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
    try {
      final created = await _cubit.createSchool(result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Supplier "${created.name}" added'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add supplier: $e'),
        ),
      );
    }
  }

  Future<void> _openEditSchoolDialog(
    BuildContext context,
    School school,
  ) async {
    if (school.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot update supplier without an ID')),
      );
      return;
    }

    final result = await showDialog<AddSchoolRequest>(
      context: context,
      builder: (_) => AddSchoolDialog(
        initial: AddSchoolRequest(
          schoolName: school.name,
          address: school.address ?? '',
          code: school.code ?? '',
          boardId: school.boardId ?? 0,
          createdById: school.createdById,
        ),
        title: 'Edit Supplier',
        confirmLabel: 'Save',
      ),
    );
    if (result == null || !context.mounted) return;
    await _cubit.updateSchool(id: school.id!, request: result);
    if (!context.mounted) return;
    final error = _cubit.state.error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error == null
              ? 'Supplier "${result.schoolName}" updated'
              : 'Update failed: $error',
        ),
      ),
    );
  }

  Future<void> _deleteSchool(BuildContext context, School school) async {
    final id = school.id;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete supplier without an ID')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Delete supplier',
        message: 'Are you sure you want to delete "${school.name}"?',
        confirmLabel: 'Delete',
        confirmColor: AppColors.accentRed,
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await _cubit.deleteSchool(id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Supplier "${school.name}" deleted')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete supplier: $e')),
      );
    }
  }

}
