import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/status_chip.dart';
import 'package:flutter/material.dart';

const double _kColumnSpacing = 24;
const double _kActionsWidth = 44;
const List<int> _kDesktopColumnFlex = [27, 8, 12, 25, 16, 12];
const List<Alignment> _kDesktopHeaderAlignment = [
  Alignment.centerLeft,
  Alignment.center,
  Alignment.center,
  Alignment.centerLeft,
  Alignment.centerLeft,
  Alignment.centerRight,
];
const List<Alignment> _kDesktopCellAlignment = _kDesktopHeaderAlignment;
const List<String> _kDesktopHeaders = [
  'Name',
  'Class',
  'Attendance %',
  'Progress %',
  'Performance',
  'Status',
];

class StudentTable extends StatelessWidget {
  const StudentTable({super.key, required this.students});

  final List<StudentReport> students;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useCards = constraints.maxWidth < 940;
        if (useCards) {
          return _StudentCardList(students: students);
        }
        return _StudentDesktopTable(students: students);
      },
    );
  }
}

class _StudentCardList extends StatelessWidget {
  const _StudentCardList({required this.students});

  final List<StudentReport> students;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < students.length; i++) ...[
          _StudentCompactCard(student: students[i]),
          if (i != students.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _StudentDesktopTable extends StatelessWidget {
  const _StudentDesktopTable({required this.students});

  final List<StudentReport> students;

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
                    'Students',
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
                const _DesktopHeaderRow(),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.studentsTableDivider),
                const SizedBox(height: 12),
                for (int i = 0; i < students.length; i++) ...[
                  _DesktopRow(student: students[i]),
                  if (i != students.length - 1)
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

class _DesktopHeaderRow extends StatelessWidget {
  const _DesktopHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < _kDesktopHeaders.length; i++) ...[
          Expanded(
            flex: _kDesktopColumnFlex[i],
            child: Align(
              alignment: _kDesktopHeaderAlignment[i],
              child: Text(
                _kDesktopHeaders[i],
                style: AppTypography.studentsTableHeader,
              ),
            ),
          ),
          if (i != _kDesktopHeaders.length - 1)
            const SizedBox(width: _kColumnSpacing),
        ],
        const SizedBox(width: _kActionsWidth),
      ],
    );
  }
}

class _DesktopRow extends StatelessWidget {
  const _DesktopRow({required this.student});

  final StudentReport student;

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < _kDesktopColumnFlex.length; i++) ...[
            Expanded(
              flex: _kDesktopColumnFlex[i],
              child: Align(
                alignment: _kDesktopCellAlignment[i],
                child: cells[i],
              ),
            ),
            if (i != _kDesktopColumnFlex.length - 1)
              const SizedBox(width: _kColumnSpacing),
          ],
          const SizedBox(width: _kActionsWidth, child: _RowActions()),
        ],
      ),
    );
  }

  List<Widget> _buildCells() {
    return [
      Text(student.name, style: AppTypography.studentsTableCell),
      Text(student.className, style: AppTypography.studentsTableCell),
      Text(
        '${(student.attendance * 100).round()}%',
        style: AppTypography.studentsTableCell,
      ),
      _ProgressCell(progress: student.progress),
      _PerformanceLabel(performance: student.performance),
      _StatusChip(status: student.status),
    ];
  }
}

class _ProgressCell extends StatelessWidget {
  const _ProgressCell({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.studentsProgressTrack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.studentsProgressValue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 48,
          child: Text(
            '${(progress * 100).round()}%',
            style: AppTypography.studentsTableCell,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

class _StudentCompactCard extends StatelessWidget {
  const _StudentCompactCard({required this.student});

  final StudentReport student;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = AppTypography.classCardMeta.copyWith(
      color: AppColors.textMuted,
      fontSize: 13,
    );
    final TextStyle valueStyle = AppTypography.studentsTableCell.copyWith(
      fontWeight: FontWeight.w600,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.studentsCardBorder.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    student.name,
                    style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                  ),
                ),
                const _RowActions(),
              ],
            ),
            const SizedBox(height: 12),
            _MetaRow(
              label: 'Class',
              value: student.className,
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
            const SizedBox(height: 6),
            _MetaRow(
              label: 'Attendance',
              value: '${(student.attendance * 100).round()}%',
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
            const SizedBox(height: 6),
            _MetaRow(
              label: 'Progress',
              value: '${(student.progress * 100).round()}%',
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
            const SizedBox(height: 12),
            _PerformanceLabel(performance: student.performance),
            const SizedBox(height: 8),
            _StatusChip(status: student.status),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label, style: labelStyle)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, style: valueStyle)),
      ],
    );
  }
}

class _PerformanceLabel extends StatelessWidget {
  const _PerformanceLabel({required this.performance});

  final StudentPerformance performance;

  @override
  Widget build(BuildContext context) {
    late final TextStyle style;
    late final String label;

    switch (performance) {
      case StudentPerformance.topPerformer:
        style = AppTypography.studentsPerformanceTop;
        label = 'Top Performer';
        break;
      case StudentPerformance.average:
        style = AppTypography.studentsPerformanceAverage;
        label = 'Average';
        break;
      case StudentPerformance.needAttention:
        style = AppTypography.studentsPerformanceAttention;
        label = 'Need Attention';
        break;
    }

    return Row(
      children: [
        Text(label, style: style),
        if (performance == StudentPerformance.topPerformer) ...[
          const SizedBox(width: 6),
          const Icon(
            Icons.star_rounded,
            color: AppColors.studentsPerformanceTop,
            size: 18,
          ),
        ],
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final StudentStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == StudentStatus.active;
    final Color background = isActive
        ? AppColors.studentsStatusActive
        : AppColors.studentsStatusInactive;
    final String label = isActive ? 'Active' : 'Inactive';

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 93),
      child: AppStatusChip(
        label: label,
        backgroundColor: background,
        textColor: AppColors.white,
        height: 27,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        radius: 14,
        textStyle: AppTypography.studentsStatusText,
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Student options',
      padding: EdgeInsets.zero,
      splashRadius: 20,
      icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
      onPressed: () {},
    );
  }
}
