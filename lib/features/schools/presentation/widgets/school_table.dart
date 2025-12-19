import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SchoolTable extends StatelessWidget {
  const SchoolTable({
    super.key,
    required this.schools,
    required this.onEdit,
    required this.onDelete,
  });

  final List<School> schools;
  final ValueChanged<School> onEdit;
  final ValueChanged<School> onDelete;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useCards = constraints.maxWidth < 940;
        if (useCards) {
          return Column(
            children: [
              for (int i = 0; i < schools.length; i++) ...[
                _SchoolCard(
                  school: schools[i],
                  onEdit: () => onEdit(schools[i]),
                  onDelete: () => onDelete(schools[i]),
                ),
                if (i != schools.length - 1) const SizedBox(height: 12),
              ],
            ],
          );
        }
        return _SchoolDesktopTable(
          schools: schools,
          onEdit: onEdit,
          onDelete: onDelete,
        );
      },
    );
  }
}

class _SchoolCard extends StatelessWidget {
  const _SchoolCard({
    required this.school,
    required this.onEdit,
    required this.onDelete,
  });

  final School school;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(school.name, style: AppTypography.subtitle)),
              IconButton(
                tooltip: 'Edit',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.accentRed,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            school.address ?? 'Address unavailable',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _MetaChip(label: 'Code', value: school.code ?? '-'),
              _MetaChip(label: 'Board', value: _boardLabel(school.boardId)),
              if (school.id != null)
                _MetaChip(label: 'ID', value: '${school.id}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _SchoolDesktopTable extends StatelessWidget {
  const _SchoolDesktopTable({
    required this.schools,
    required this.onEdit,
    required this.onDelete,
  });

  final List<School> schools;
  final ValueChanged<School> onEdit;
  final ValueChanged<School> onDelete;

  static const double _columnSpacing = 24;
  static const double _actionsWidth = 80;
  static const List<int> _flex = [22, 24, 16, 12, 10];
  static const List<String> _headers = [
    'Name',
    'Address',
    'Code',
    'Board',
    'ID',
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
        for (int i = 0; i < schools.length; i++) ...[
          _SchoolRow(
            school: schools[i],
            flex: _flex,
            onEdit: () => onEdit(schools[i]),
            onDelete: () => onDelete(schools[i]),
          ),
          if (i != schools.length - 1)
            const Divider(height: 1, color: AppColors.studentsTableDivider),
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
            const SizedBox(width: _SchoolDesktopTable._columnSpacing),
        ],
        const SizedBox(width: _SchoolDesktopTable._actionsWidth),
      ],
    );
  }
}

class _SchoolRow extends StatelessWidget {
  const _SchoolRow({
    required this.school,
    required this.flex,
    required this.onEdit,
    required this.onDelete,
  });

  final School school;
  final List<int> flex;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: flex[0],
            child: Text(school.name, style: AppTypography.studentsTableCell),
          ),
          Expanded(
            flex: flex[1],
            child: Text(
              school.address ?? '',
              style: AppTypography.studentsTableCell,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: flex[2],
            child: Text(
              school.code ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          Expanded(
            flex: flex[3],
            child: Text(
              _boardLabel(school.boardId),
              style: AppTypography.studentsTableCell,
            ),
          ),
          Expanded(
            flex: flex[4],
            child: Text(
              school.id?.toString() ?? '',
              style: AppTypography.studentsTableCell,
            ),
          ),
          const SizedBox(width: _SchoolDesktopTable._actionsWidth),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Edit',
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                onPressed: onEdit,
              ),
              IconButton(
                tooltip: 'Delete',
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.accentRed,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.syllabusSectionBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: AppTypography.bodySmall),
          Text(
            value,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String _boardLabel(int? boardId) {
  switch (boardId) {
    case 1:
      return 'CBSE';
    case 2:
      return 'ICSE';
    case 3:
      return 'State Board';
    default:
      return boardId == null ? '-' : 'Board $boardId';
  }
}
