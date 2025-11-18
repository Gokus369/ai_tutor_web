import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_modules_view.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_students_table.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_summary_card.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key, required this.data});

  final ProgressPageData data;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late ProgressView _activeView = ProgressView.modules;
  late String _selectedClass;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.data.classes.isEmpty) {
      _selectedClass = widget.data.initialClass;
    } else if (widget.data.classes.containsKey(widget.data.initialClass)) {
      _selectedClass = widget.data.initialClass;
    } else {
      _selectedClass = widget.data.classes.keys.first;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ClassProgressData get _activeClassData {
    return widget.data.resolveClass(_selectedClass);
  }

  List<StudentProgress> get _filteredStudents {
    final query = _searchController.text.trim().toLowerCase();
    final students = _activeClassData.students;
    if (query.isEmpty) return students;
    return students
        .where((student) => student.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.progress,
      title: 'Progress',
      alignContentToStart: true,
      maxContentWidth: 1200,
      builder: (context, shell) {
        final double effectiveWidth = shell.contentWidth.clamp(0.0, 1200.0);
        final bool compact = effectiveWidth < 960;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressSummaryCard(
              summary: _activeClassData.summary,
              compact: compact,
              classOptions: widget.data.classOptions,
              selectedClass: _selectedClass,
              view: _activeView,
              onClassChanged: (value) {
                if (value == null ||
                    value == _selectedClass ||
                    !widget.data.classes.containsKey(value)) {
                  return;
                }
                setState(() {
                  _selectedClass = value;
                  _searchController.clear();
                });
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
                detail: _activeClassData.mathematics,
                additionalSubjects: _activeClassData.additionalSubjects,
                compact: compact,
              )
            else
              ProgressStudentsTable(
                students: _filteredStudents,
                compact: compact,
              ),
          ],
        );
      },
    );
  }
}
