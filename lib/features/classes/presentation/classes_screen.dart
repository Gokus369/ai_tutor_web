import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/class_filters.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/data/classes_repository.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/new_class_button.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/classes_content.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/confirmation_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/create_class_dialog.dart';
import 'package:ai_tutor_web/features/auth/application/auth_cubit.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/models/school_option.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:dio/dio.dart';

const List<String> _boardOptions = [
  'All Boards',
  'CBSE',
  'ICSE',
  'State Board',
];

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBoard = _boardOptions.first;
  final List<ClassInfo> _classes = [];
  late final ClassesRepository _repository;
  late final SchoolRepository _schoolRepository;
  List<SchoolOption> _schoolOptions = const [];

  @override
  void initState() {
    super.initState();
    _repository = ClassesRepository(context.read<ApiClient>());
    _schoolRepository = SchoolRepository(context.read<ApiClient>());
    _searchController.addListener(_handleSearchChanged);
    _loadSchools();
    _loadGrades();
  }

  Future<void> _createGrade(CreateClassRequest request) async {
    try {
      final grade = await _repository.createGrade(request);
      setState(() {
        _classes.insert(0, _mapGradeToClassInfo(grade));
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class "${grade.name}" created')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create class: $e')),
      );
    }
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() => setState(() {});

  Future<void> _loadSchools() async {
    final cubitSchools = context.read<SchoolCubit>().state.schools;
    if (cubitSchools.isNotEmpty) {
      setState(() {
        _schoolOptions = cubitSchools
            .where((s) => s.id != null)
            .map(
              (s) => SchoolOption(
                id: s.id!,
                name: s.name,
              ),
            )
            .toList();
      });
      return;
    }

    try {
      final page = await _schoolRepository.fetchSchools(take: 100);
      setState(() {
        _schoolOptions = page.data
            .map(
              (s) => SchoolOption(
                id: s.id ?? 0,
                name: (s.name).trim().isEmpty && s.id != null
                    ? 'School ${s.id}'
                    : s.name,
              ),
            )
            .where((opt) => opt.id != 0)
            .toList();
        if (_schoolOptions.isEmpty) {
          _schoolOptions = const [];
        }
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

  Future<void> _openCreateClassDialog() async {
    final List<String> boardChoices = _boardOptions
        .where((option) => option != _boardOptions.first)
        .toList();

    final CreateClassRequest? result = await showDialog<CreateClassRequest>(
      context: context,
      builder: (context) => CreateClassDialog(
        boardOptions: boardChoices,
        schoolOptions: _schoolOptions,
      ),
    );

    if (result == null) return;
    await _createGrade(result);
  }

  Future<void> _handlePatchClass(ClassInfo info) async {
    final classId = _safeReadInt(() => info.id);
    if (classId == null || classId <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class data is outdated. Please refresh and try again.')),
      );
      await _loadGrades();
      return;
    }

    final List<String> boardChoices = _boardOptions
        .where((option) => option != _boardOptions.first)
        .toList();
    final bool hasBoard = boardChoices.contains(info.board);
    final String resolvedBoard = hasBoard
        ? info.board
        : (boardChoices.isNotEmpty ? boardChoices.first : info.board);
    final int resolvedBoardId = hasBoard
        ? (_safeReadInt(() => info.boardId) ?? _boardIdFromLabel(resolvedBoard))
        : _boardIdFromLabel(resolvedBoard);
    final int? resolvedSchoolId =
        _safeReadInt(() => info.schoolId) ??
        (_schoolOptions.isNotEmpty ? _schoolOptions.first.id : null);
    if (resolvedSchoolId == null || resolvedSchoolId <= 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('School information is missing for this class.')),
      );
      return;
    }

    final result = await showDialog<CreateClassRequest>(
      context: context,
      builder: (_) => CreateClassDialog(
        boardOptions: boardChoices,
        schoolOptions: _schoolOptions,
        title: 'Edit Class',
        confirmLabel: 'Save',
        initial: CreateClassRequest(
          className: info.name,
          board: resolvedBoard,
          boardId: resolvedBoardId,
          schoolId: resolvedSchoolId,
          section: info.section,
          startDate: info.startDate,
        ),
      ),
    );

    if (result == null) return;
    try {
      final updated = await _repository.updateGrade(classId, result);
      setState(() {
        final index = _classes.indexWhere((item) => item.id == info.id);
        if (index != -1) {
          _classes[index] = _mapGradeToClassInfo(updated);
        }
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class "${updated.name}" updated')),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is DioException ? _parseDioMessage(e) : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update class: $message')),
      );
    }
  }

  Future<void> _handleDeleteClass(ClassInfo info) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: 'Delete class',
        message: 'Are you sure you want to delete "${info.name}"?',
        confirmLabel: 'Delete',
        confirmColor: AppColors.accentRed,
      ),
    );
    if (confirmed != true || !mounted) return;

    final classId = _safeReadInt(() => info.id);
    if (classId == null || classId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class data is outdated. Please refresh and try again.')),
      );
      await _loadGrades();
      return;
    }

    final deletedById = _resolveDeletedById();
    if (deletedById == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete class without a user ID')),
      );
      return;
    }

    try {
      await _repository.deleteGrade(id: classId, deletedById: deletedById);
      setState(() => _classes.removeWhere((item) => item.id == classId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class "${info.name}" deleted')),
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is DioException ? _parseDioMessage(e) : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete class: $message')),
      );
    }
  }

  Future<void> _loadGrades() async {
    try {
      final page = await _repository.fetchGrades(take: 50);
      setState(() {
        _classes
          ..clear()
          ..addAll(page.data.map(_mapGradeToClassInfo));
      });
    } catch (e) {
      if (!mounted) return;
      final message = e is DioException ? _parseDioMessage(e) : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load classes: $message')),
      );
    }
  }

  ClassInfo _mapGradeToClassInfo(Grade grade) {
    final boardLabel =
        grade.boardName?.trim().isNotEmpty == true
            ? grade.boardName!
            : _boardLabelFromId(grade.boardId);
    final subjectSummary = grade.section?.isNotEmpty == true
        ? 'Section ${grade.section}'
        : 'No subjects added yet';
    final startDate = grade.startDateIso == null
        ? null
        : DateTime.tryParse(grade.startDateIso!);
    return ClassInfo(
      id: grade.id,
      name: grade.name,
      board: boardLabel,
      boardId: grade.boardId,
      schoolId: grade.schoolId,
      schoolName: grade.schoolName,
      section: grade.section,
      startDate: startDate,
      studentCount: 0,
      subjectSummary: subjectSummary,
      syllabusProgress: 0,
    );
  }

  String _boardLabelFromId(int boardId) {
    switch (boardId) {
      case 1:
        return 'CBSE';
      case 2:
        return 'ICSE';
      case 3:
        return 'State Board';
      default:
        return 'Board $boardId';
    }
  }

  int _boardIdFromLabel(String? label) {
    switch (label?.toLowerCase()) {
      case 'cbse':
        return 1;
      case 'icse':
        return 2;
      case 'state board':
        return 3;
      default:
        return 1;
    }
  }

  int? _safeReadInt(int Function() reader) {
    try {
      return reader();
    } catch (_) {
      return null;
    }
  }

  int? _resolveDeletedById() {
    final userId = context.read<AuthCubit>().state.user?.id;
    return int.tryParse(userId ?? '');
  }

  List<ClassInfo> get _filteredClasses {
    return filterClasses(
      _classes,
      options: ClassFilterOptions(
        searchTerm: _searchController.text,
        selectedBoard: _selectedBoard,
        allBoardsLabel: _boardOptions.first,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.classes,
      title: 'Classes',
      titleSpacing: 20,
      headerBuilder: (context, shell) {
        final bool isCompact = shell.contentWidth < 480;
        return isCompact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Classes', style: AppTypography.dashboardTitle),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: NewClassButton(onPressed: _openCreateClassDialog),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Text('Classes', style: AppTypography.dashboardTitle),
                  ),
                  SizedBox(
                    height: 44,
                    child: NewClassButton(onPressed: _openCreateClassDialog),
                  ),
                ],
              );
      },
      builder: (context, shell) {
        final bool isCompact = shell.contentWidth < 760;
        return ClassesContent(
          isCompact: isCompact,
          classes: _filteredClasses,
          boardOptions: _boardOptions,
          selectedBoard: _selectedBoard,
          searchController: _searchController,
          contentWidth: shell.contentWidth,
          onBoardChanged: (value) => setState(() => _selectedBoard = value),
          onPatch: _handlePatchClass,
          onDelete: _handleDeleteClass,
        );
      },
    );
  }
}
