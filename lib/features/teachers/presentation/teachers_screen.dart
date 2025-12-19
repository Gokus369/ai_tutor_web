import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/shared/models/school_option.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/teacher_filters_bar.dart';
import 'widgets/teachers_view.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  final List<AddTeacherRequest> _teachers = [];
  late final SchoolRepository _schoolRepository;
  List<SchoolOption> _schoolOptions = const [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedSchool = 'All Schools';
  String _selectedSubject = 'All Subjects';

  @override
  void initState() {
    super.initState();
    _schoolRepository = SchoolRepository(context.read<ApiClient>());
    _loadSchools();
    _searchController.addListener(_handleFilterChange);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleFilterChange)
      ..dispose();
    super.dispose();
  }

  void _handleFilterChange() => setState(() {});

  List<String> get _schoolFilterOptions {
    final names = _schoolOptions.map((s) => s.name).toList();
    return ['All Schools', ...names];
  }

  List<String> get _subjectFilterOptions {
    final subjects =
        _teachers
            .map((t) => t.subject?.trim())
            .where((s) => s != null && s!.isNotEmpty)
            .map((s) => s!)
            .toSet()
            .toList()
          ..sort();
    return ['All Subjects', ...subjects];
  }

  List<AddTeacherRequest> get _filteredTeachers {
    final search = _searchController.text.toLowerCase().trim();
    return _teachers.where((teacher) {
      final matchesSearch =
          search.isEmpty ||
          teacher.name.toLowerCase().contains(search) ||
          teacher.email.toLowerCase().contains(search) ||
          (teacher.subject ?? '').toLowerCase().contains(search) ||
          (teacher.schoolName ?? '').toLowerCase().contains(search);
      final matchesSchool =
          _selectedSchool == 'All Schools' ||
          teacher.schoolName == _selectedSchool;
      final matchesSubject =
          _selectedSubject == 'All Subjects' ||
          teacher.subject == _selectedSubject;
      return matchesSearch && matchesSchool && matchesSubject;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.teachers,
      title: 'Teachers',
      builder: (context, shell) {
        return TeachersView(
          searchController: _searchController,
          teachers: _filteredTeachers,
          schoolOptions: _schoolFilterOptions,
          subjectOptions: _subjectFilterOptions,
          selectedSchool: _selectedSchool,
          selectedSubject: _selectedSubject,
          onSchoolChanged: (value) => setState(() => _selectedSchool = value),
          onSubjectChanged: (value) => setState(() => _selectedSubject = value),
          onAddTeacher: _openAddTeacherDialog,
          onRemoveTeacher: (teacher) {
            setState(() => _teachers.remove(teacher));
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
    setState(() => _teachers.add(result));
    if (_selectedSchool == 'All Schools' &&
        result.schoolName != null &&
        result.schoolName!.isNotEmpty) {
      _selectedSchool = 'All Schools';
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Teacher "${result.name}" added')));
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
