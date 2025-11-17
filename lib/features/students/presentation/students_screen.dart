import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/features/students/domain/student_filters.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/student_filters_bar.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/student_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

const List<String> _classOptions = [
  'All Classes',
  'Class 12',
  'Class 11',
  'Class 10',
  'Class 9',
  'Class 8',
  'Class 7',
];

const List<String> _attendanceOptions = [
  'All Attendance',
  'Above 90%',
  '70% - 90%',
  'Below 70%',
];

const List<String> _progressOptions = [
  'All Progress',
  'Above 80%',
  '50% - 80%',
  'Below 50%',
];

const List<String> _performanceOptions = [
  'All Levels',
  'Top Performer',
  'Average',
  'Need Attention',
];

final List<StudentReport> _seedStudents = [
  const StudentReport(
    name: 'Rowan Hahn',
    className: 'Class 12',
    attendance: 0.92,
    progress: 0.85,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Giovanni Fields',
    className: 'Class 12',
    attendance: 0.86,
    progress: 0.46,
    performance: StudentPerformance.needAttention,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Rowen Holland',
    className: 'Class 11',
    attendance: 0.91,
    progress: 0.58,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Celeste Moore',
    className: 'Class 10',
    attendance: 0.70,
    progress: 0.52,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Matteo Nelson',
    className: 'Class 9',
    attendance: 0.65,
    progress: 0.79,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Elise Gill',
    className: 'Class 8',
    attendance: 0.73,
    progress: 0.90,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Gerardo Dillon',
    className: 'Class 7',
    attendance: 0.97,
    progress: 0.33,
    performance: StudentPerformance.needAttention,
    status: StudentStatus.inactive,
  ),
];

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<StudentReport> _students = List.of(_seedStudents);
  String _selectedClass = _classOptions.first;
  String _selectedAttendance = _attendanceOptions.first;
  String _selectedProgress = _progressOptions.first;
  String _selectedPerformance = _performanceOptions.first;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleFilterChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleFilterChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFilterChanged() => setState(() {});

  List<StudentReport> get _filteredStudents {
    return filterStudents(
      _students,
      options: StudentFilterOptions(
        searchTerm: _searchController.text,
        classOption: _selectedClass,
        attendanceOption: _selectedAttendance,
        progressOption: _selectedProgress,
        performanceOption: _selectedPerformance,
        allClassesLabel: _classOptions.first,
        allAttendanceLabel: _attendanceOptions.first,
        allProgressLabel: _progressOptions.first,
        allPerformanceLabel: _performanceOptions.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.students,
      title: 'Students',
      titleSpacing: 20,
      headerBuilder: (context, shell) {
        final bool isCompactHeader = shell.contentWidth < 640;
        return _Header(
          isCompact: isCompactHeader,
          onAddStudent: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add student tapped')),
            );
          },
        );
      },
      builder: (context, shell) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: StudentFiltersBar(
                isCompact: shell.contentWidth < 820,
                classOptions: _classOptions,
                attendanceOptions: _attendanceOptions,
                progressOptions: _progressOptions,
                performanceOptions: _performanceOptions,
                selectedClass: _selectedClass,
                selectedAttendance: _selectedAttendance,
                selectedProgress: _selectedProgress,
                selectedPerformance: _selectedPerformance,
                searchController: _searchController,
                onClassChanged: (value) => setState(() => _selectedClass = value),
                onAttendanceChanged: (value) =>
                    setState(() => _selectedAttendance = value),
                onProgressChanged: (value) =>
                    setState(() => _selectedProgress = value),
                onPerformanceChanged: (value) =>
                    setState(() => _selectedPerformance = value),
              ),
            ),
            const SizedBox(height: 24),
            if (_filteredStudents.isEmpty)
              const _EmptyState()
            else
              StudentTable(students: _filteredStudents),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isCompact, required this.onAddStudent});

  final bool isCompact;
  final VoidCallback onAddStudent;

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Students', style: AppTypography.dashboardTitle),
          const SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: onAddStudent,
              child: const Text('+ Add Student'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Text('Students', style: AppTypography.dashboardTitle),
        ),
        SizedBox(
          width: 156,
          height: 48,
          child: ElevatedButton(
            onPressed: onAddStudent,
            child: const Text('+ Add Student'),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Text(
        'No students match your filters. Try adjusting search or filters.',
        style: AppTypography.classCardMeta,
      ),
    );
  }
}
