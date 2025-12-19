import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/features/students/domain/student_filters.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/students_header.dart';
import 'package:ai_tutor_web/features/students/presentation/widgets/students_view.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
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
  const StudentReport(
    name: 'Amelia Turner',
    className: 'Class 12',
    attendance: 0.88,
    progress: 0.61,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Liam Watson',
    className: 'Class 11',
    attendance: 0.94,
    progress: 0.77,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Noah Patel',
    className: 'Class 10',
    attendance: 0.68,
    progress: 0.41,
    performance: StudentPerformance.needAttention,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Mia Rodriguez',
    className: 'Class 9',
    attendance: 0.81,
    progress: 0.58,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Ethan Cooper',
    className: 'Class 8',
    attendance: 0.75,
    progress: 0.49,
    performance: StudentPerformance.needAttention,
    status: StudentStatus.inactive,
  ),
  const StudentReport(
    name: 'Sophia Nguyen',
    className: 'Class 7',
    attendance: 0.90,
    progress: 0.86,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Ava Stewart',
    className: 'Class 12',
    attendance: 0.79,
    progress: 0.73,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Oliver Brooks',
    className: 'Class 11',
    attendance: 0.84,
    progress: 0.57,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Isabella King',
    className: 'Class 10',
    attendance: 0.96,
    progress: 0.91,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Lucas Evans',
    className: 'Class 9',
    attendance: 0.71,
    progress: 0.36,
    performance: StudentPerformance.needAttention,
    status: StudentStatus.inactive,
  ),
  const StudentReport(
    name: 'Harper Scott',
    className: 'Class 8',
    attendance: 0.89,
    progress: 0.64,
    performance: StudentPerformance.average,
    status: StudentStatus.active,
  ),
  const StudentReport(
    name: 'Henry Barnes',
    className: 'Class 7',
    attendance: 0.93,
    progress: 0.82,
    performance: StudentPerformance.topPerformer,
    status: StudentStatus.active,
  ),
];

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const int _pageSize = 10;
  final List<StudentReport> _students = List.of(_seedStudents);
  String _selectedClass = _classOptions.first;
  String _selectedAttendance = _attendanceOptions.first;
  String _selectedProgress = _progressOptions.first;
  String _selectedPerformance = _performanceOptions.first;
  int _currentPage = 1;

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

  void _handleFilterChanged() {
    setState(() {
      _currentPage = 1;
    });
  }

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

  int get _pageCount {
    final total = _filteredStudents.length;
    if (total == 0) return 0;
    return (total / _pageSize).ceil();
  }

  List<StudentReport> get _pagedStudents {
    final filtered = _filteredStudents;
    if (filtered.isEmpty) return const [];
    final start = (_currentPage - 1) * _pageSize;
    return filtered.skip(start).take(_pageSize).toList();
  }

  void _goToPage(int page) {
    final pageCount = _pageCount;
    if (pageCount == 0) return;
    final nextPage = page < 1
        ? 1
        : (page > pageCount ? pageCount : page);
    setState(() => _currentPage = nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.students,
      title: 'Students',
      titleSpacing: 20,
      headerBuilder: (context, shell) {
        final bool isCompactHeader = shell.contentWidth < 640;
        return StudentsHeader(
          isCompact: isCompactHeader,
          onAddStudent: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add student tapped')),
            );
          },
        );
      },
      builder: (context, shell) {
        final pageCount = _pageCount;
        final currentPage = pageCount == 0 ? 1 : _currentPage;
        return StudentsView(
          students: _pagedStudents,
          classOptions: _classOptions,
          attendanceOptions: _attendanceOptions,
          progressOptions: _progressOptions,
          performanceOptions: _performanceOptions,
          selectedClass: _selectedClass,
          selectedAttendance: _selectedAttendance,
          selectedProgress: _selectedProgress,
          selectedPerformance: _selectedPerformance,
          searchController: _searchController,
          onClassChanged: (value) {
            setState(() {
              _selectedClass = value;
              _currentPage = 1;
            });
          },
          onAttendanceChanged: (value) {
            setState(() {
              _selectedAttendance = value;
              _currentPage = 1;
            });
          },
          onProgressChanged: (value) {
            setState(() {
              _selectedProgress = value;
              _currentPage = 1;
            });
          },
          onPerformanceChanged: (value) {
            setState(() {
              _selectedPerformance = value;
              _currentPage = 1;
            });
          },
          isCompactFilters: shell.contentWidth < 820,
          currentPage: currentPage,
          totalPages: pageCount == 0 ? 1 : pageCount,
          showPagination: pageCount > 1,
          onPreviousPage: currentPage > 1
              ? () => _goToPage(currentPage - 1)
              : null,
          onNextPage: currentPage < pageCount
              ? () => _goToPage(currentPage + 1)
              : null,
        );
      },
    );
  }
}
