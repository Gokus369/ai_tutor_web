import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_teacher_dialog.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class TeachersTable extends StatelessWidget {
  const TeachersTable({
    super.key,
    required this.teachers,
    required this.onRemove,
  });

  final List<AddTeacherRequest> teachers;
  final ValueChanged<AddTeacherRequest> onRemove;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useCards = constraints.maxWidth < 940;
        if (useCards) {
          return _TeacherCardList(teachers: teachers, onRemove: onRemove);
        }
        return _TeacherDesktopTable(teachers: teachers, onRemove: onRemove);
      },
    );
  }
}

class _TeacherCardList extends StatelessWidget {
  const _TeacherCardList({required this.teachers, required this.onRemove});

  final List<AddTeacherRequest> teachers;
  final ValueChanged<AddTeacherRequest> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < teachers.length; i++) ...[
          _TeacherCard(
            teacher: teachers[i],
            onRemove: () => onRemove(teachers[i]),
          ),
          if (i != teachers.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.teacher, required this.onRemove});

  final AddTeacherRequest teacher;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            foregroundColor: AppColors.primary,
            child: Text(
              teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : '?',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(teacher.name, style: AppTypography.subtitle),
                const SizedBox(height: 4),
                Text(teacher.email, style: AppTypography.bodySmall),
                if ((teacher.schoolName ?? '').isNotEmpty)
                  Text(teacher.schoolName!, style: AppTypography.bodySmall),
                if ((teacher.subject ?? '').isNotEmpty)
                  Text(
                    'Subject: ${teacher.subject}',
                    style: AppTypography.bodySmall,
                  ),
                if ((teacher.phone ?? '').isNotEmpty)
                  Text(teacher.phone!, style: AppTypography.bodySmall),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove',
            icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _TeacherDesktopTable extends StatelessWidget {
  const _TeacherDesktopTable({required this.teachers, required this.onRemove});

  final List<AddTeacherRequest> teachers;
  final ValueChanged<AddTeacherRequest> onRemove;

  static const double _columnSpacing = 24;
  static const double _actionsWidth = 44;
  static const List<int> _flex = [18, 22, 18, 18, 16];
  static const List<String> _headers = [
    'Name',
    'Email',
    'School',
    'Subject',
    'Phone',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.studentsHeaderBackground,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Teachers',
                    style: AppTypography.syllabusSectionHeading,
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.studentsFilterBorder),
                    color: AppColors.studentsFilterBackground,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text(
                      'All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderRow(headers: _headers, flex: _flex),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.studentsTableDivider),
                const SizedBox(height: 12),
                for (int i = 0; i < teachers.length; i++) ...[
                  _TeacherRow(
                    teacher: teachers[i],
                    flex: _flex,
                    onRemove: () => onRemove(teachers[i]),
                  ),
                  if (i != teachers.length - 1)
                    const Divider(
                      height: 1,
                      color: AppColors.studentsTableDivider,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.headers, required this.flex});

  final List<String> headers;
  final List<int> flex;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < headers.length; i++) ...[
          Expanded(
            flex: flex[i],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(headers[i], style: AppTypography.studentsTableHeader),
            ),
          ),
          if (i != headers.length - 1)
            const SizedBox(width: _TeacherDesktopTable._columnSpacing),
        ],
        const SizedBox(width: _TeacherDesktopTable._actionsWidth),
      ],
    );
  }
}

class _TeacherRow extends StatelessWidget {
  const _TeacherRow({
    required this.teacher,
    required this.flex,
    required this.onRemove,
  });

  final AddTeacherRequest teacher;
  final List<int> flex;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: flex[0],
            child: Text(teacher.name, style: AppTypography.studentsTableCell),
          ),
          Expanded(
            flex: flex[1],
            child: Text(teacher.email, style: AppTypography.studentsTableCell),
          ),
          Expanded(
            flex: flex[2],
            child: Text(
              teacher.schoolName ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          Expanded(
            flex: flex[3],
            child: Text(
              teacher.subject ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          Expanded(
            flex: flex[4],
            child: Text(
              teacher.phone ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          const SizedBox(width: _TeacherDesktopTable._actionsWidth),
          IconButton(
            tooltip: 'Remove',
            icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
