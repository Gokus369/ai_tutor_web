import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/features/teachers/domain/models/teacher.dart';
import 'package:ai_tutor_web/features/teachers/presentation/bloc/teacher_cubit.dart';
import 'package:ai_tutor_web/shared/models/school_option.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/teachers_header.dart';
import 'widgets/teachers_view.dart';

const List<String> _attendanceOptions = [
  'All Attendance',
  'Above 90%',
  '70% - 90%',
  'Below 70%',
];

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  TeacherCubit get _cubit => context.read<TeacherCubit>();
  late final SchoolRepository _schoolRepository;
  List<SchoolOption> _schoolOptions = const [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedSchool = 'All Schools';
  String _selectedSubject = 'All Subjects';
  String? _selectedAttendance = _attendanceOptions.first;
  static const int _pageSize = 10;
  static const int _fetchSize = 100;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _schoolRepository = SchoolRepository(context.read<ApiClient>());
    _loadSchools();
    if (_cubit.state.status == TeacherStatus.initial) {
      _cubit.loadTeachers(take: _fetchSize);
    }
    _searchController.addListener(_handleFilterChange);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleFilterChange)
      ..dispose();
    super.dispose();
  }

  void _handleFilterChange() {
    setState(() {
      _currentPage = 1;
    });
  }

  List<String> get _schoolFilterOptions {
    final names = _schoolOptions.map((s) => s.name).toList();
    return ['All Schools', ...names];
  }

  List<String> _subjectFilterOptions(List<Teacher> teachers) {
    final subjects =
        teachers
            .map((t) => t.subject?.trim())
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return ['All Subjects', ...subjects];
  }

  List<Teacher> _filteredTeachers(
    List<Teacher> teachers, {
    required String selectedSchool,
    required String selectedSubject,
    required String selectedAttendance,
  }) {
    final search = _searchController.text.toLowerCase().trim();
    return teachers.where((teacher) {
      final matchesSearch =
          search.isEmpty ||
          teacher.name.toLowerCase().contains(search) ||
          teacher.email.toLowerCase().contains(search) ||
          (teacher.subject ?? '').toLowerCase().contains(search) ||
          (teacher.schoolName ?? '').toLowerCase().contains(search);
      final matchesSchool =
          selectedSchool == 'All Schools' ||
          teacher.schoolName == selectedSchool;
      final matchesSubject =
          selectedSubject == 'All Subjects' ||
          teacher.subject == selectedSubject;
      final matchesAttendance = _matchesAttendance(
        teacher.attendance,
        selectedAttendance,
      );
      return matchesSearch &&
          matchesSchool &&
          matchesSubject &&
          matchesAttendance;
    }).toList();
  }

  bool _matchesAttendance(double? value, String selectedAttendance) {
    if (selectedAttendance == _attendanceOptions.first) return true;
    if (value == null || value.isNaN) return false;
    final normalized = value <= 1 ? value : value / 100;
    switch (selectedAttendance) {
      case 'Above 90%':
        return normalized >= 0.9;
      case '70% - 90%':
        return normalized >= 0.7 && normalized < 0.9;
      case 'Below 70%':
        return normalized < 0.7;
      default:
        return true;
    }
  }

  int _pageCount(List<Teacher> filteredTeachers) {
    final total = filteredTeachers.length;
    if (total == 0) return 0;
    return (total / _pageSize).ceil();
  }

  List<Teacher> _pagedTeachers(List<Teacher> filtered, int currentPage) {
    if (filtered.isEmpty) return const [];
    final start = (currentPage - 1) * _pageSize;
    return filtered.skip(start).take(_pageSize).toList();
  }

  void _goToPage(int page, int pageCount) {
    if (pageCount == 0) return;
    final nextPage = page < 1
        ? 1
        : (page > pageCount ? pageCount : page);
    setState(() => _currentPage = nextPage);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.teachers,
      title: 'Teachers',
      titleSpacing: 20,
      headerBuilder: (context, shell) {
        final bool isCompactHeader = shell.contentWidth < 640;
        return TeachersHeader(
          isCompact: isCompactHeader,
          onAddTeacher: _openAddTeacherDialog,
        );
      },
      builder: (context, shell) {
        return BlocBuilder<TeacherCubit, TeacherState>(
          builder: (context, state) {
            final loading = state.status == TeacherStatus.loading;
            final error = state.error;
            final schoolOptions = _schoolFilterOptions;
            final subjectOptions = _subjectFilterOptions(state.teachers);
            final selectedAttendance =
                _selectedAttendance ?? _attendanceOptions.first;
            final selectedSchool = schoolOptions.contains(_selectedSchool)
                ? _selectedSchool
                : schoolOptions.first;
            final selectedSubject = subjectOptions.contains(_selectedSubject)
                ? _selectedSubject
                : subjectOptions.first;
            final filteredTeachers = _filteredTeachers(
              state.teachers,
              selectedSchool: selectedSchool,
              selectedSubject: selectedSubject,
              selectedAttendance: selectedAttendance,
            );
            final pageCount = _pageCount(filteredTeachers);
            final currentPage =
                pageCount == 0 ? 1 : _currentPage.clamp(1, pageCount).toInt();
            final pagedTeachers = _pagedTeachers(filteredTeachers, currentPage);
            final hasTeachers = filteredTeachers.isNotEmpty;

            return TeachersView(
              searchController: _searchController,
              teachers: pagedTeachers,
              schoolOptions: schoolOptions,
              subjectOptions: subjectOptions,
              attendanceOptions: _attendanceOptions,
              selectedSchool: selectedSchool,
              selectedSubject: selectedSubject,
              selectedAttendance: selectedAttendance,
              onSchoolChanged: (value) {
                setState(() {
                  _selectedSchool = value;
                  _currentPage = 1;
                });
              },
              onSubjectChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                  _currentPage = 1;
                });
              },
              onAttendanceChanged: (value) {
                setState(() {
                  _selectedAttendance = value;
                  _currentPage = 1;
                });
              },
              onEditTeacher: _openEditTeacherDialog,
              onRemoveTeacher: _deleteTeacher,
              isCompactFilters: shell.contentWidth < 820,
              currentPage: currentPage,
              totalPages: pageCount == 0 ? 1 : pageCount,
              showPagination: hasTeachers,
              isLoading: loading,
              error: error,
              onRetry: () => _cubit.loadTeachers(take: _fetchSize),
              onPreviousPage: currentPage > 1
                  ? () => _goToPage(currentPage - 1, pageCount)
                  : null,
              onNextPage: currentPage < pageCount
                  ? () => _goToPage(currentPage + 1, pageCount)
                  : null,
            );
          },
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
    try {
      final created = await _cubit.createTeacher(result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher "${created.name}" added')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add teacher: $e')),
      );
    }
  }

  Future<void> _openEditTeacherDialog(Teacher teacher) async {
    final id = teacher.id;
    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot update teacher without an ID')),
      );
      return;
    }

    if (_schoolOptions.isEmpty) {
      await _loadSchools();
      if (!mounted) return;
    }

    final resolvedSchoolId = _resolveSchoolId(teacher);
    final result = await showDialog<AddTeacherRequest>(
      context: context,
      builder: (_) => AddTeacherDialog(
        schoolOptions: _schoolOptions,
        initial: AddTeacherRequest(
          name: teacher.name,
          email: teacher.email,
          phone: teacher.phone,
          subject: teacher.subject,
          attendance: teacher.attendance,
          schoolId: resolvedSchoolId,
          schoolName: teacher.schoolName,
        ),
        title: 'Edit Teacher',
        confirmLabel: 'Save',
        allowEmailEdit: false,
      ),
    );
    if (result == null || !mounted) return;
    try {
      final updated = await _cubit.updateTeacher(id: id, request: result);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher "${updated.name}" updated')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update teacher: $e')),
      );
    }
  }

  Future<void> _deleteTeacher(Teacher teacher) async {
    final id = teacher.id;
    if (id == null) {
      _cubit.removeLocal(teacher);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher "${teacher.name}" removed')),
      );
      return;
    }

    try {
      await _cubit.deleteTeacher(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Teacher "${teacher.name}" deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete teacher: $e')),
      );
    }
  }

  int? _resolveSchoolId(Teacher teacher) {
    if (teacher.schoolId != null) return teacher.schoolId;
    final name = teacher.schoolName;
    if (name == null || name.trim().isEmpty) return null;
    final match = _schoolOptions.firstWhere(
      (option) => option.name == name,
      orElse: () => const SchoolOption(id: 0, name: ''),
    );
    return match.id == 0 ? null : match.id;
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
      _selectedSchool = 'All Schools';
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
