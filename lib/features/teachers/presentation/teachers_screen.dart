import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/models/school_option.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final List<AddTeacherRequest> _teachers = [];
  late final SchoolRepository _schoolRepository;
  List<SchoolOption> _schoolOptions = const [];

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
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: AppTypography.button.copyWith(fontSize: 17),
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
                  ? const Text(
                      'No teachers yet. Add your first teacher to get started.',
                      style: TextStyle(fontSize: 16),
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
                          title: Text(teacher.name, style: AppTypography.subtitle),
                      subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(teacher.email),
                              if (teacher.schoolName != null &&
                                  teacher.schoolName!.isNotEmpty)
                                Text(teacher.schoolName!),
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
    if (_schoolOptions.isEmpty) {
      await _loadSchools();
      if (!mounted) return;
    }
    final result = await showDialog<AddTeacherRequest>(
      context: context,
      builder: (_) => AddTeacherDialog(schoolOptions: _schoolOptions),
    );
    if (result == null || !mounted) return;
    setState(() => _teachers.add(result));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Teacher "${result.name}" added')),
    );
  }

  @override
  void initState() {
    super.initState();
    _schoolRepository = SchoolRepository(context.read<ApiClient>());
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    final cubitSchools = context.read<SchoolCubit>().state.schools;
    if (cubitSchools.isNotEmpty) {
      setState(() {
        _schoolOptions = cubitSchools
            .where((s) => s.id != null)
            .map((s) => SchoolOption(id: s.id!, name: s.name))
            .toList();
      });
      return;
    }

    try {
      final page = await _schoolRepository.fetchSchools(take: 100);
      setState(() {
        _schoolOptions = page.data
            .where((s) => s.id != null)
            .map((s) => SchoolOption(id: s.id!, name: s.name))
            .toList();
      });
    } catch (e) {
      if (!mounted) return;
      final message = e is DioException ? _parseDioMessage(e) : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load schools: $message')),
      );
    }
  }

  String _parseDioMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message']?.toString() ?? data['error']?.toString();
      if (msg != null && msg.trim().isNotEmpty) return msg;
    }
    return e.message ?? 'Network error';
  }
}
