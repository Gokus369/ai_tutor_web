import 'package:ai_tutor_web/features/teachers/domain/models/teacher.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class TeachersTable extends StatelessWidget {
  const TeachersTable({
    super.key,
    required this.teachers,
    required this.onEdit,
    required this.onRemove,
  });

  final List<Teacher> teachers;
  final ValueChanged<Teacher> onEdit;
  final ValueChanged<Teacher> onRemove;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useCards = constraints.maxWidth < 940;
        if (useCards) {
          return _TeacherCardList(
            teachers: teachers,
            onEdit: onEdit,
            onRemove: onRemove,
          );
        }
        return _TeacherDesktopTable(
          teachers: teachers,
          onEdit: onEdit,
          onRemove: onRemove,
        );
      },
    );
  }
}

class _TeacherCardList extends StatelessWidget {
  const _TeacherCardList({
    required this.teachers,
    required this.onEdit,
    required this.onRemove,
  });

  final List<Teacher> teachers;
  final ValueChanged<Teacher> onEdit;
  final ValueChanged<Teacher> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < teachers.length; i++) ...[
          _TeacherCard(
            teacher: teachers[i],
            onEdit: () => onEdit(teachers[i]),
            onRemove: () => onRemove(teachers[i]),
          ),
          if (i != teachers.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({
    required this.teacher,
    required this.onEdit,
    required this.onRemove,
  });

  final Teacher teacher;
  final VoidCallback onEdit;
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
                if (teacher.attendance != null)
                  Text(
                    'Attendance: ${_formatAttendance(teacher.attendance)}',
                    style: AppTypography.bodySmall,
                  ),
                if ((teacher.phone ?? '').isNotEmpty)
                  Text(teacher.phone!, style: AppTypography.bodySmall),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: onEdit,
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _TeacherDesktopTable extends StatelessWidget {
  const _TeacherDesktopTable({
    required this.teachers,
    required this.onEdit,
    required this.onRemove,
  });

  final List<Teacher> teachers;
  final ValueChanged<Teacher> onEdit;
  final ValueChanged<Teacher> onRemove;

  static const double _columnSpacing = 24;
  static const double _actionsWidth = 96;
  static const double _actionCellWidth = 48;
  static const List<int> _flex = [16, 22, 18, 16, 12, 12];
  static const List<String> _headers = [
    'Name',
    'Email',
    'School',
    'Subject',
    'Attendance %',
    'Phone',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
            onEdit: () => onEdit(teachers[i]),
            onRemove: () => onRemove(teachers[i]),
          ),
          if (i != teachers.length - 1)
            const Divider(
              height: 1,
              color: AppColors.studentsTableDivider,
            ),
        ],
      ],
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
        SizedBox(
          width: _TeacherDesktopTable._actionsWidth,
          child: Row(
            children: [
              SizedBox(
                width: _TeacherDesktopTable._actionCellWidth,
                child: Text(
                  'Edit',
                  textAlign: TextAlign.center,
                  style: AppTypography.studentsTableHeader,
                ),
              ),
              SizedBox(
                width: _TeacherDesktopTable._actionCellWidth,
                child: Text(
                  'Delete',
                  textAlign: TextAlign.center,
                  style: AppTypography.studentsTableHeader,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TeacherRow extends StatelessWidget {
  const _TeacherRow({
    required this.teacher,
    required this.flex,
    required this.onEdit,
    required this.onRemove,
  });

  final Teacher teacher;
  final List<int> flex;
  final VoidCallback onEdit;
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
          const SizedBox(width: _TeacherDesktopTable._columnSpacing),
          Expanded(
            flex: flex[1],
            child: Text(teacher.email, style: AppTypography.studentsTableCell),
          ),
          const SizedBox(width: _TeacherDesktopTable._columnSpacing),
          Expanded(
            flex: flex[2],
            child: Text(
              teacher.schoolName ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          const SizedBox(width: _TeacherDesktopTable._columnSpacing),
          Expanded(
            flex: flex[3],
            child: Text(
              teacher.subject ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          const SizedBox(width: _TeacherDesktopTable._columnSpacing),
          Expanded(
            flex: flex[4],
            child: Text(
              _formatAttendance(teacher.attendance),
              style: AppTypography.studentsTableCell,
            ),
          ),
          const SizedBox(width: _TeacherDesktopTable._columnSpacing),
          Expanded(
            flex: flex[5],
            child: Text(
              teacher.phone ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          SizedBox(
            width: _TeacherDesktopTable._actionsWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: _TeacherDesktopTable._actionCellWidth,
                  child: IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: onEdit,
                  ),
                ),
                SizedBox(
                  width: _TeacherDesktopTable._actionCellWidth,
                  child: IconButton(
                    tooltip: 'Delete',
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.accentRed,
                    ),
                    onPressed: onRemove,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatAttendance(double? value) {
  if (value == null || value.isNaN) return '-';
  final normalized = value <= 1 ? value : value / 100;
  return '${(normalized * 100).round()}%';
}
