import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_school_dialog.dart';
import 'package:ai_tutor_web/features/schools/application/schools_cubit.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:ai_tutor_web/features/schools/domain/models/school.dart';
import 'package:ai_tutor_web/features/schools/presentation/widgets/school_card.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SchoolsScreen extends StatelessWidget {
  const SchoolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SchoolsCubit, SchoolsState>(
      builder: (context, state) {
        if (state.status == SchoolsStatus.initial && !state.isLoading) {
          context.read<SchoolsCubit>().loadSchools();
        }

        return _SchoolsView(
          state: state,
          onAddSchool: () => _openAddSchoolDialog(context),
          onEditSchool: (school) => _showUnsupported(context),
          onDeleteSchool: (school) => _removeSchool(context, school),
          onRetry: () => context.read<SchoolsCubit>().loadSchools(),
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

    final messenger = ScaffoldMessenger.of(context);
    try {
      final created = await context.read<SchoolsCubit>().createSchool(result);
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('School "${created.schoolName}" added')),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _showUnsupported(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Editing schools is not available yet.'),
      ),
    );
  }

  void _removeSchool(BuildContext context, School school) {
    context.read<SchoolsCubit>().removeFromCache(school.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('School "${school.schoolName}" removed locally'),
      ),
    );
  }
}

class _SchoolsView extends StatelessWidget {
  const _SchoolsView({
    required this.state,
    required this.onAddSchool,
    required this.onEditSchool,
    required this.onDeleteSchool,
    required this.onRetry,
  });

  final SchoolsState state;
  final VoidCallback onAddSchool;
  final ValueChanged<School> onEditSchool;
  final ValueChanged<School> onDeleteSchool;
  final VoidCallback onRetry;

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
                  label: Text(
                    state.isSubmitting ? 'Adding...' : 'Add School',
                    style: AppTypography.button.copyWith(
                      fontSize: 15,
                      letterSpacing: 0.2,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: AppColors.primary.withValues(alpha: 0.35),
                  ),
                  onPressed: state.isSubmitting ? null : onAddSchool,
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
                  if (state.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state.status == SchoolsStatus.failure)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.error ?? 'Failed to load schools.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.accentRed,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: onRetry,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  else if (state.schools.isEmpty)
                    const Text(
                      'No schools added yet. Use "Add School" to create one.',
                      style: TextStyle(color: AppColors.textMuted),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.schools.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final school = state.schools[index];
                        return SchoolCard(
                          school: school,
                          onEdit: () => onEditSchool(school),
                          onDelete: () => onDeleteSchool(school),
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
}
