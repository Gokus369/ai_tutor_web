import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/lessons/domain/lesson_filters.dart';
import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';
import 'package:ai_tutor_web/features/lessons/presentation/widgets/add_lesson_dialog.dart';
import 'package:ai_tutor_web/features/lessons/presentation/widgets/lesson_filters.dart';
import 'package:ai_tutor_web/features/lessons/presentation/widgets/lessons_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class LessonsPlannerScreen extends StatefulWidget {
  const LessonsPlannerScreen({super.key});

  @override
  State<LessonsPlannerScreen> createState() => _LessonsPlannerScreenState();
}

const List<String> _classOptions = [
  'All Classes',
  'Class 12',
  'Class 11',
  'Class 10',
];

const List<String> _subjectOptions = [
  'All Subjects',
  'Mathematics',
  'Science',
  'English',
  'History',
];

final List<LessonPlan> _seedPlans = [
  LessonPlan(
    date: DateTime(2025, 8, 31),
    className: 'Class 12',
    subject: 'Mathematics',
    description: 'Chapter 1: Linear Equations',
    topic: 'Linear Equations Introduction',
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 0),
    status: LessonStatus.pending,
  ),
  LessonPlan(
    date: DateTime(2025, 8, 30),
    className: 'Class 12',
    subject: 'Mathematics',
    description: 'Chapter 1: Linear Equations',
    topic: 'Solving Word Problems',
    startTime: const TimeOfDay(hour: 9, minute: 0),
    endTime: const TimeOfDay(hour: 10, minute: 0),
    status: LessonStatus.pending,
  ),
  LessonPlan(
    date: DateTime(2025, 8, 28),
    className: 'Class 11',
    subject: 'Science',
    description: 'Chapter 5: Matter in Our Surroundings',
    topic: 'States of Matter',
    startTime: const TimeOfDay(hour: 11, minute: 0),
    endTime: const TimeOfDay(hour: 12, minute: 0),
    status: LessonStatus.pending,
  ),
  LessonPlan(
    date: DateTime(2025, 8, 27),
    className: 'Class 11',
    subject: 'English',
    description: 'Chapter 3: Literature',
    topic: 'Poetry Analysis Workshop',
    startTime: const TimeOfDay(hour: 14, minute: 0),
    endTime: const TimeOfDay(hour: 15, minute: 0),
    status: LessonStatus.pending,
  ),
  LessonPlan(
    date: DateTime(2025, 8, 26),
    className: 'Class 10',
    subject: 'Mathematics',
    description: 'Chapter 2: Geometry',
    topic: 'Geometry Review',
    startTime: const TimeOfDay(hour: 11, minute: 0),
    endTime: const TimeOfDay(hour: 12, minute: 0),
    status: LessonStatus.completed,
  ),
  LessonPlan(
    date: DateTime(2025, 8, 25),
    className: 'Class 10',
    subject: 'Mathematics',
    description: 'Chapter 2: Geometry',
    topic: 'Geometry Review',
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    status: LessonStatus.completed,
  ),
  LessonPlan(
    date: DateTime(2025, 8, 24),
    className: 'Class 10',
    subject: 'English',
    description: 'Chapter 3: Literature',
    topic: 'Geometry Review',
    startTime: const TimeOfDay(hour: 14, minute: 0),
    endTime: const TimeOfDay(hour: 15, minute: 0),
    status: LessonStatus.completed,
  ),
];

class _LessonsPlannerScreenState extends State<LessonsPlannerScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<LessonPlan> _plans = List.of(_seedPlans);
  String _selectedClass = _classOptions.first;
  String _selectedSubject = _subjectOptions.first;

  @override
  void initState() {
    super.initState();
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
        allClassLabel: _classOptions.first,
        allSubjectLabel: _subjectOptions.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.lessons,
      builder: (context, shell) {
        final bool isCompact = shell.contentWidth < 880;
        final bool isTablet = shell.isTablet || shell.contentWidth < 1100;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(isCompact: isCompact, onAddLesson: _openAddLessonDialog),
            const SizedBox(height: 24),
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
