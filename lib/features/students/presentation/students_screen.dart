import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  String _classFilter = 'All Class';
  String _attendanceFilter = 'All Attendance';
  String _progressFilter = 'All Progress';
  String _levelFilter = 'All Levels';

  static final List<StudentReport> _students = [
    const StudentReport(
      name: 'Rowan Hahn',
      className: '12',
      attendance: 0.92,
      progress: 0.85,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Giovanni Fields',
      className: '12',
      attendance: 0.86,
      progress: 0.46,
      performance: StudentPerformance.needAttention,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Rowen Holland',
      className: '11',
      attendance: 0.91,
      progress: 0.58,
      performance: StudentPerformance.average,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Celeste Moore',
      className: '10',
      attendance: 0.70,
      progress: 0.52,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Matteo Nelson',
      className: '9',
      attendance: 0.65,
      progress: 0.79,
      performance: StudentPerformance.average,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Elise Gill',
      className: '8',
      attendance: 0.73,
      progress: 0.90,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Gerardo Dillon',
      className: '7',
      attendance: 0.97,
      progress: 0.33,
      performance: StudentPerformance.needAttention,
      status: StudentStatus.inactive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.students,
      builder: (context, shell) {
        final double width = shell.contentWidth;
        final bool isCompact = width < 960;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (width >= 640)
              Row(
                children: [
                  Expanded(
                    child: Text('Students', style: AppTypography.dashboardTitle),
                  ),
                  SizedBox(
                    width: 156,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        textStyle: AppTypography.button,
                      ),
                      child: const Text('+ Add Student'),
                    ),
                  ),
                ],
              )
            else ...[
              Text('Students', style: AppTypography.dashboardTitle),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    textStyle: AppTypography.button,
                  ),
                  child: const Text('+ Add Student'),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: AppColors.studentsCardBackground,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, filterConstraints) {
                  final double maxWidth = filterConstraints.maxWidth;
                  const double spacing = 12;
                  final bool narrow = maxWidth < 720;
                  final bool medium = maxWidth < 960 && !narrow;

                  double dropdownWidth;
                  if (narrow) {
                    dropdownWidth = maxWidth;
                  } else if (medium) {
                    dropdownWidth = ((maxWidth - spacing) / 2).clamp(160.0, 260.0);
                  } else {
                    dropdownWidth = 150;
                  }

                  final double searchWidth = narrow ? maxWidth : 360;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: [
                      SizedBox(
                        width: searchWidth,
                        child: _StudentSearchField(
                          height: 38,
                          width: searchWidth,
                          borderRadius: 24,
                        ),
                      ),
                      SizedBox(
                        width: dropdownWidth,
                        child: _FilterDropdown(
                          height: 38,
                          borderRadius: 24,
                          value: _classFilter,
                          items: const ['All Class', 'Class 12', 'Class 11', 'Class 10'],
                          onChanged: (value) => setState(() => _classFilter = value),
                        ),
                      ),
                      SizedBox(
                        width: dropdownWidth,
                        child: _FilterDropdown(
                          height: 38,
                          borderRadius: 24,
                          value: _attendanceFilter,
                          items: const ['All Attendance', 'Above 90%', '70% - 90%', 'Below 70%'],
                          onChanged: (value) => setState(() => _attendanceFilter = value),
                        ),
                      ),
                      SizedBox(
                        width: dropdownWidth,
                        child: _FilterDropdown(
                          height: 38,
                          borderRadius: 24,
                          value: _progressFilter,
                          items: const ['All Progress', 'Above 80%', '50% - 80%', 'Below 50%'],
                          onChanged: (value) => setState(() => _progressFilter = value),
                        ),
                      ),
                      SizedBox(
                        width: dropdownWidth,
                        child: _FilterDropdown(
                          height: 38,
                          borderRadius: 24,
                          value: _levelFilter,
                          items: const ['All Levels', 'Top Performer', 'Average', 'Need Attention'],
                          onChanged: (value) => setState(() => _levelFilter = value),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _StudentsTable(
              students: _students,
              compact: isCompact,
            ),
          ],
        );
      },
    );
  }
}

class _StudentSearchField extends StatelessWidget {
  const _StudentSearchField({this.height = 44, this.width, this.borderRadius = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search students by name, class...',
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 10),
            child: Icon(Icons.search, color: AppColors.iconMuted, size: 20),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
          filled: true,
          fillColor: AppColors.studentsSearchBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          hintStyle: AppTypography.classCardMeta.copyWith(color: AppColors.iconMuted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColors.studentsSearchBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColors.studentsSearchBorder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  final double height;
  final double? width;
  final double borderRadius;
}

class _FilterDropdown extends StatelessWidget {
  const _FilterDropdown({
    required this.height,
    required this.value,
    required this.items,
    required this.onChanged,
    this.borderRadius = 14,
  });

  final double height;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.studentsFilterBackground,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.studentsFilterBorder),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
              style: AppTypography.classCardMeta,
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
              items: [
                for (final item in items)
                  DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentsTable extends StatelessWidget {
  const _StudentsTable({required this.students, this.compact = false});

  final List<StudentReport> students;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useCompact = compact || constraints.maxWidth < 940;

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
                padding: EdgeInsets.symmetric(horizontal: useCompact ? 20 : 28, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.studentsHeaderBackground,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Students', style: AppTypography.syllabusSectionHeading),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.studentsFilterBorder),
                        color: AppColors.studentsFilterBackground,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Text('All', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              if (useCompact)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    children: [
                      for (int i = 0; i < students.length; i++) ...[
                        _StudentCompactCard(student: students[i]),
                        if (i != students.length - 1) const SizedBox(height: 16),
                      ],
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                  child: _DesktopStudentsTable(students: students),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _DesktopStudentsTable extends StatelessWidget {
  const _DesktopStudentsTable({required this.students});

  final List<StudentReport> students;

  static const double _actionsWidth = 44;
  static const double _columnSpacing = 24;
  static const List<int> _columnFlex = [
    27, // Name
    8, // Class
    12, // Attendance
    25, // Progress
    16, // Performance
    12, // Status
  ];

  static const List<Alignment> _headerAlignments = [
    Alignment.centerLeft,
    Alignment.center,
    Alignment.center,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.center,
  ];

  static const List<Alignment> _cellAlignments = [
    Alignment.centerLeft,
    Alignment.center,
    Alignment.center,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.center,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _DesktopHeaderRow(),
        const SizedBox(height: 14),
        for (int i = 0; i < students.length; i++) ...[
          _DesktopStudentRow(student: students[i]),
          if (i != students.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1, color: AppColors.studentsTableDivider),
            ),
        ],
      ],
    );
  }
}

class _DesktopHeaderRow extends StatelessWidget {
  const _DesktopHeaderRow();

  static const List<String> _labels = [
    'Name',
    'Class',
    'Attendance %',
    'Progress %',
    'Performance',
    'Status',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.studentsFilterBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.studentsFilterBorder, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < _labels.length; i++) ...[
                  Expanded(
                    flex: _DesktopStudentsTable._columnFlex[i],
                    child: Align(
                      alignment: _DesktopStudentsTable._headerAlignments[i],
                      child: Text(
                        _labels[i],
                        style: AppTypography.studentsTableHeader,
                      ),
                    ),
                  ),
                  if (i != _labels.length - 1) ...[
                    const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                    const _ColumnDivider(),
                    const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                  ],
                ],
                const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                const _ColumnDivider(),
                const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                SizedBox(
                  width: _DesktopStudentsTable._actionsWidth,
                  child: const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: AppColors.studentsTableDivider,
          ),
        ],
      ),
    );
  }
}

class _DesktopStudentRow extends StatelessWidget {
  const _DesktopStudentRow({required this.student});

  final StudentReport student;

  @override
  Widget build(BuildContext context) {
    Widget progressCell() {
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
                widthFactor: student.progress.clamp(0, 1),
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
              '${(student.progress * 100).round()}%',
              style: AppTypography.studentsTableCell,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
    }

    Widget buildCell(int index) {
      switch (index) {
        case 0:
          return Text(student.name, style: AppTypography.studentsTableCell);
        case 1:
          return Text(student.className, style: AppTypography.studentsTableCell);
        case 2:
          return Text('${(student.attendance * 100).round()}%',
              style: AppTypography.studentsTableCell);
        case 3:
          return progressCell();
        case 4:
          return _PerformanceLabel(performance: student.performance);
        case 5:
          return _StatusChip(status: student.status);
      }
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < _DesktopStudentsTable._columnFlex.length; i++) ...[
                  Expanded(
                    flex: _DesktopStudentsTable._columnFlex[i],
                    child: Align(
                      alignment: _DesktopStudentsTable._cellAlignments[i],
                      child: buildCell(i),
                    ),
                  ),
                  if (i != _DesktopStudentsTable._columnFlex.length - 1) ...[
                    const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                    const _ColumnDivider(),
                    const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                  ],
                ],
                const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                const _ColumnDivider(),
                const SizedBox(width: _DesktopStudentsTable._columnSpacing / 2),
                const SizedBox(width: _DesktopStudentsTable._actionsWidth, child: _RowActions()),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            color: AppColors.studentsTableDivider,
          ),
        ],
      ),
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
        border: Border.all(color: AppColors.studentsCardBorder.withValues(alpha: 0.6)),
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
                IconButton(
                  tooltip: 'Student options',
                  padding: EdgeInsets.zero,
                  splashRadius: 18,
                  icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            _MetaRow(label: 'Class', value: student.className, labelStyle: labelStyle, valueStyle: valueStyle),
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
          const Icon(Icons.star_rounded, color: AppColors.studentsPerformanceTop, size: 18),
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
    final Color background = status == StudentStatus.active
        ? AppColors.studentsStatusActive
        : AppColors.studentsStatusInactive;
    final String label = status == StudentStatus.active ? 'Active' : 'Inactive';

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.studentsStatusText,
        ),
      ),
    );
  }
}

class _RowActions extends StatelessWidget {
  const _RowActions();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        tooltip: 'Student options',
        padding: EdgeInsets.zero,
        splashRadius: 20,
        icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
        onPressed: () {},
      ),
    );
  }
}

class _ColumnDivider extends StatelessWidget {
  const _ColumnDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: AppColors.studentsTableDivider,
      ),
    );
  }
}
