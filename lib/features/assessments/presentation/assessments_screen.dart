import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/assessments/data/assessment_demo_data.dart';
import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_summary_card.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_table_section.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AssessmentsScreen extends StatefulWidget {
  AssessmentsScreen({super.key, AssessmentsPageData? data})
      : data = data ?? AssessmentDemoData.build();

  final AssessmentsPageData data;

  @override
  State<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> {
  late String _selectedClass;
  late String _selectedStatus;
  late String _selectedSubject;
  late AssessmentView _view;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final filters = widget.data.filters;
    _selectedClass = filters.initialClass;
    _selectedStatus = filters.initialStatus;
    _selectedSubject = filters.initialSubject;
    _view = AssessmentView.assignments;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  AssessmentSectionData get _currentSection => widget.data.sections[_view]!;

  List<AssessmentRecord> get _filteredRecords {
    final records = _currentSection.records;
    final query = _searchController.text.trim().toLowerCase();
    return records.where((record) {
      final matchesQuery = query.isEmpty || record.title.toLowerCase().contains(query);
      final matchesSubject = _selectedSubject == widget.data.filters.subjectOptions.first || record.subject == _selectedSubject;
      final matchesStatus = _selectedStatus == widget.data.filters.statusOptions.first || record.status.label == _selectedStatus;
      final matchesClass = record.className == _selectedClass;
      return matchesQuery && matchesSubject && matchesStatus && matchesClass;
    }).toList();
  }

  void _onClassChanged(String? value) {
    if (value == null) return;
    setState(() => _selectedClass = value);
  }

  void _onStatusChanged(String? value) {
    if (value == null) return;
    setState(() => _selectedStatus = value);
  }

  void _onSubjectChanged(String? value) {
    if (value == null) return;
    setState(() => _selectedSubject = value);
  }

  void _onSearchChanged(String value) => setState(() {});

  void _onViewChanged(AssessmentView view) {
    if (view == _view) return;
    setState(() => _view = view);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.assessments,
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
                Text('Assessments', style: AppTypography.dashboardTitle),
                const SizedBox(height: 24),
                AssessmentsSummaryCard(
                  filters: widget.data.filters,
                  activeView: _view,
                  onViewChanged: _onViewChanged,
                  onClassChanged: _onClassChanged,
                  onStatusChanged: _onStatusChanged,
                  onSubjectChanged: _onSubjectChanged,
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                ),
                const SizedBox(height: 28),
                AssessmentsTableSection(
                  title: _sectionTitle(_view),
                  section: _currentSection.copyWith(records: _filteredRecords),
                  compact: compact,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _sectionTitle(AssessmentView view) {
    switch (view) {
      case AssessmentView.assignments:
        return 'Assignments';
      case AssessmentView.quizzes:
        return 'Quizzes';
      case AssessmentView.exams:
        return 'Exams';
    }
  }
}

extension on AssessmentSectionData {
  AssessmentSectionData copyWith({List<AssessmentRecord>? records}) {
    if (records == null) return this;
    return AssessmentSectionData(view: view, records: records, columns: columns);
  }
}
