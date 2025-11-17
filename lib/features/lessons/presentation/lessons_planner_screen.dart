import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/lessons/data/lessons_planner_demo_data.dart';
import 'package:ai_tutor_web/features/lessons/domain/lesson_filters.dart';
import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';
import 'package:ai_tutor_web/features/lessons/presentation/widgets/add_lesson_dialog.dart';
import 'package:ai_tutor_web/features/lessons/presentation/widgets/lesson_filters.dart';
import 'package:ai_tutor_web/features/lessons/presentation/widgets/lessons_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class LessonsPlannerScreen extends StatefulWidget {
  const LessonsPlannerScreen({super.key});

  @override
  State<LessonsPlannerScreen> createState() => _LessonsPlannerScreenState();
}

class _LessonsPlannerScreenState extends State<LessonsPlannerScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<LessonPlan> _plans;
  late String _selectedClass;
  late String _selectedSubject;

  List<String> get _classOptions => LessonsPlannerDemoData.classOptions;
  List<String> get _subjectOptions => LessonsPlannerDemoData.subjectOptions;

  @override
  void initState() {
    super.initState();
    _plans = List.of(LessonsPlannerDemoData.plans);
    _selectedClass = LessonsPlannerDemoData.classOptions.first;
    _selectedSubject = LessonsPlannerDemoData.subjectOptions.first;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  List<LessonPlan> get _filteredPlans {
    return filterLessons(
      _plans,
      options: LessonFilterOptions(
        selectedClass: _selectedClass,
        selectedSubject: _selectedSubject,
        query: _searchController.text,
        allClassLabel: LessonsPlannerDemoData.classOptions.first,
        allSubjectLabel: LessonsPlannerDemoData.subjectOptions.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.lessons,
      title: 'Lessons Planner',
      headerBuilder: (context, shell) {
        final bool isCompact = shell.contentWidth < 880;
        return _Header(
          isCompact: isCompact,
          onAddLesson: _openAddLessonDialog,
        );
      },
      builder: (context, shell) {
        final bool isCompact = shell.contentWidth < 880;
        final bool isTablet = shell.isTablet || shell.contentWidth < 1100;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LessonsFilters(
              isCompact: isCompact,
              isTablet: isTablet,
              classOptions: _classOptions,
              subjectOptions: _subjectOptions,
              selectedClass: _selectedClass,
              selectedSubject: _selectedSubject,
              searchController: _searchController,
              onClassChanged: (value) => setState(() => _selectedClass = value),
              onSubjectChanged: (value) =>
                  setState(() => _selectedSubject = value),
            ),
            const SizedBox(height: 24),
            LessonsTable(
              plans: _filteredPlans,
              onRowMenuTap: (plan) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lesson menu tapped for ${plan.subject}'),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openAddLessonDialog() async {
    final subjects = _subjectOptions
        .where((value) => value != _subjectOptions.first)
        .toList();
    final classes = _classOptions
        .where((value) => value != _classOptions.first)
        .toList();
    if (classes.isEmpty) return;
    final String defaultClass = _selectedClass == _classOptions.first
        ? classes.first
        : _selectedClass;
    final LessonPlan? newPlan = await showAddLessonDialog(
      context: context,
      subjects: subjects,
      className: defaultClass,
    );
    if (newPlan != null) {
      setState(() => _plans = List.of(_plans)..add(newPlan));
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isCompact, required this.onAddLesson});

  final bool isCompact;
  final VoidCallback onAddLesson;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Lessons Planner', style: AppTypography.dashboardTitle),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: onAddLesson,
              icon: const Icon(Icons.add),
              label: const Text('Add Lesson'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text('Lessons Planner', style: AppTypography.dashboardTitle),
        ),
        SizedBox(
          width: 163,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: onAddLesson,
            icon: const Icon(Icons.add),
            label: const Text('Add Lesson'),
          ),
        ),
      ],
    );
  }
}
