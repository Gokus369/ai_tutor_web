import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_school_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/confirmation_dialog.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/section_card.dart' as shared;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/school_table.dart' as school_widgets;

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  SchoolCubit get _cubit => context.read<SchoolCubit>();
  final TextEditingController _searchController = TextEditingController();
  String _selectedBoard = 'All Boards';

  static const List<String> _boardOptions = [
    'All Boards',
    'CBSE',
    'ICSE',
    'State Board',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<School> _filtered(List<School> schools) {
    final needle = _searchController.text.trim().toLowerCase();
    return schools.where((s) {
      final matchesSearch =
          needle.isEmpty ||
          s.name.toLowerCase().contains(needle) ||
          (s.code ?? '').toLowerCase().contains(needle) ||
          (s.address ?? '').toLowerCase().contains(needle);
      final matchesBoard =
          _selectedBoard == 'All Boards' ||
          (_selectedBoard == 'CBSE' && (s.boardId == 1)) ||
          (_selectedBoard == 'ICSE' && (s.boardId == 2)) ||
          (_selectedBoard == 'State Board' && (s.boardId == 3));
      return matchesSearch && matchesBoard;
    }).toList();
  }

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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
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
            _FiltersBar(
              controller: _searchController,
              boardOptions: _boardOptions,
              selectedBoard: _selectedBoard,
              onBoardChanged: (value) => setState(() => _selectedBoard = value),
            ),
            const SizedBox(height: 16),
            BlocBuilder<SchoolCubit, SchoolState>(
              builder: (context, state) {
                final loading = state.status == SchoolStatus.loading;
                final error = state.error;
                final schools = _filtered(state.schools);

                return shared.SectionCard(
                  title: 'Supplier list',
                  trailing: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.studentsFilterBorder),
                      color: AppColors.studentsFilterBackground,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      child: Text(
                        'All',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (loading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
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
                                style: const TextStyle(
                                  color: AppColors.accentRed,
                                ),
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
                          ),
                        )
                      else if (schools.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'No suppliers found. Adjust filters and try again.',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        )
                      else
                        school_widgets.SchoolTable(
                          schools: schools,
                          onEdit: (school) =>
                              _openEditSchoolDialog(context, school),
                          onDelete: (school) => _deleteSchool(context, school),
                        ),
                    ],
                  ),
                );
              },
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
        SnackBar(content: Text('Supplier "${created.name}" added')),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add supplier: $e')));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete supplier: $e')));
    }
  }
}

class _FiltersBar extends StatelessWidget {
  const _FiltersBar({
    this.controller,
    required this.boardOptions,
    required this.selectedBoard,
    required this.onBoardChanged,
  });

  final TextEditingController? controller;
  final List<String> boardOptions;
  final String selectedBoard;
  final ValueChanged<String> onBoardChanged;

  @override
  Widget build(BuildContext context) {
    const double gap = 12;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search suppliers by name, code, address...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.iconMuted,
                  ),
                  filled: true,
                  fillColor: AppColors.studentsSearchBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.studentsSearchBorder,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.studentsSearchBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: gap),
          Expanded(
            child: _Dropdown(
              label: 'Board',
              value: selectedBoard,
              items: boardOptions,
              onChanged: onBoardChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({
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
        Text(
          label,
          style: AppTypography.classCardMeta.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
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
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textPrimary,
                ),
                style: AppTypography.classCardMeta,
                onChanged: (val) {
                  if (val == null) return;
                  onChanged(val);
                },
                items: items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
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
