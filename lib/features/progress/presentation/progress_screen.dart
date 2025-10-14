import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_modules_view.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_students_table.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_summary_card.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.data});

  final ProgressPageData data;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late ProgressView _activeView = ProgressView.modules;
  late String _selectedClass = widget.data.initialClass;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<StudentProgress> get _filteredStudents {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return widget.data.students;
    return widget.data.students
        .where((student) => student.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.progress,
      builder: (context, shell) {
        final double contentWidth = shell.contentWidth;
        final double resolvedWidth = contentWidth >= 1200 ? 1200 : contentWidth;
        final bool compact = resolvedWidth < 960;

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: resolvedWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress', style: AppTypography.dashboardTitle),
                const SizedBox(height: 24),
                ProgressSummaryCard(
                  summary: widget.data.summary,
                  compact: compact,
                  classOptions: widget.data.classOptions,
                  selectedClass: _selectedClass,
                  view: _activeView,
                  onClassChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedClass = value);
                  },
                  onViewChanged: (view) {
                    if (view == _activeView) return;
                    setState(() {
                      _activeView = view;
                      if (view == ProgressView.modules) {
                        _searchController.clear();
                      }
                    });
                  },
                  searchController: _searchController,
                  onSearchChanged: _activeView == ProgressView.students
                      ? (_) => setState(() {})
                      : null,
                ),
                const SizedBox(height: 28),
                if (_activeView == ProgressView.modules)
                  ProgressModulesView(
                    detail: widget.data.mathematics,
                    additionalSubjects: widget.data.additionalSubjects,
                    compact: compact,
                  )
                else
                  ProgressStudentsTable(
                    students: _filteredStudents,
                    compact: compact,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
