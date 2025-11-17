import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/class_filters.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_filters_bar.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_grid.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/create_class_dialog.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

const List<String> _boardOptions = [
  'All Boards',
  'CBSE',
  'ICSE',
  'State Board',
];

final List<ClassInfo> _seedClasses = [
  const ClassInfo(
    name: 'Class 12',
    board: 'CBSE',
    studentCount: 45,
    subjectSummary: 'Mathematics, English, Physics, Computer Science',
    syllabusProgress: 0.74,
  ),
  const ClassInfo(
    name: 'Class 11',
    board: 'CBSE',
    studentCount: 38,
    subjectSummary: 'Mathematics, Chemistry, Biology, English',
    syllabusProgress: 0.62,
  ),
  const ClassInfo(
    name: 'Class 10',
    board: 'ICSE',
    studentCount: 50,
    subjectSummary: 'Mathematics, English, History, Physics',
    syllabusProgress: 0.71,
  ),
  const ClassInfo(
    name: 'Class 9',
    board: 'State Board',
    studentCount: 42,
    subjectSummary: 'Mathematics, English, Malayalam, Physics',
    syllabusProgress: 0.48,
  ),
  const ClassInfo(
    name: 'Class 8',
    board: 'State Board',
    studentCount: 38,
    subjectSummary: 'Mathematics, English, Malayalam, Physics',
    syllabusProgress: 0.59,
  ),
  const ClassInfo(
    name: 'Class 7',
    board: 'CBSE',
    studentCount: 46,
    subjectSummary: 'Mathematics, English, Malayalam, Physics',
    syllabusProgress: 0.35,
  ),
];

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBoard = _boardOptions.first;
  final List<ClassInfo> _classes = List.of(_seedClasses);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _handleSearchChanged() => setState(() {});

  Future<void> _openCreateClassDialog() async {
    final List<String> boardChoices = _boardOptions
        .where((option) => option != _boardOptions.first)
        .toList();

    final CreateClassRequest? result = await showDialog<CreateClassRequest>(
      context: context,
      builder: (context) => CreateClassDialog(boardOptions: boardChoices),
    );

    if (result == null) return;

    setState(() {
      _classes.insert(
        0,
        ClassInfo(
          name: result.className,
          board: result.board,
          studentCount: 0,
          subjectSummary: 'No subjects added yet',
          syllabusProgress: 0,
        ),
      );
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Class "${result.className}" created')),
    );
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
                    child: _NewClassButton(onPressed: _openCreateClassDialog),
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
                    child: _NewClassButton(onPressed: _openCreateClassDialog),
                  ),
                ],
              );
      },
      builder: (context, shell) {
        final bool isCompact = shell.contentWidth < 760;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClassFiltersBar(
              isCompact: isCompact,
              boardOptions: _boardOptions,
              selectedBoard: _selectedBoard,
              searchController: _searchController,
              onBoardChanged: (value) => setState(() => _selectedBoard = value),
            ),
            const SizedBox(height: 24),
            if (_filteredClasses.isEmpty)
              const _EmptyState()
            else
              ClassGrid(
                classes: _filteredClasses,
                contentWidth: shell.contentWidth,
              ),
          ],
        );
      },
    );
  }
}

class _NewClassButton extends StatelessWidget {
  const _NewClassButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 20),
      label: Text('New Class', style: AppTypography.button),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
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
        'No classes match your filters. Try adjusting the search or board.',
        style: AppTypography.classCardMeta,
      ),
    );
  }
}
