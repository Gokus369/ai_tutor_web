import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_top_bar.dart';
import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardSidebar(activeRoute: AppRoutes.students),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.dashboardGradientTop, AppColors.dashboardGradientBottom],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DashboardTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 32),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 1200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Students', style: AppTypography.dashboardTitle),
                                    const Spacer(),
                                    SizedBox(
                                      width: 163,
                                      height: 50,
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
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: 1138,
                                  height: 78,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: AppColors.studentsCardBackground,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.08),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const _StudentSearchField(height: 38, width: 367, borderRadius: 24),
                                      const SizedBox(width: 18),
                                      _FilterDropdown(
                                        width: 121,
                                        height: 38,
                                        borderRadius: 24,
                                        value: _classFilter,
                                        items: const ['All Class', 'Class 12', 'Class 11', 'Class 10'],
                                        onChanged: (value) => setState(() => _classFilter = value),
                                      ),
                                      const SizedBox(width: 12),
                                      _FilterDropdown(
                                        width: 144,
                                        height: 38,
                                        borderRadius: 24,
                                        value: _attendanceFilter,
                                        items: const ['All Attendance', 'Above 90%', '70% - 90%', 'Below 70%'],
                                        onChanged: (value) => setState(() => _attendanceFilter = value),
                                      ),
                                      const SizedBox(width: 12),
                                      _FilterDropdown(
                                        width: 133,
                                        height: 38,
                                        borderRadius: 24,
                                        value: _progressFilter,
                                        items: const ['All Progress', 'Above 80%', '50% - 80%', 'Below 50%'],
                                        onChanged: (value) => setState(() => _progressFilter = value),
                                      ),
                                      const SizedBox(width: 12),
                                      _FilterDropdown(
                                        width: 120,
                                        height: 38,
                                        borderRadius: 24,
                                        value: _levelFilter,
                                        items: const ['All Levels', 'Top Performer', 'Average', 'Need Attention'],
                                        onChanged: (value) => setState(() => _levelFilter = value),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),
                                _StudentsTable(students: _students),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentSearchField extends StatelessWidget {
  const _StudentSearchField({super.key, this.height = 44, this.width, this.borderRadius = 14});

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
    required this.width,
    required this.height,
    required this.value,
    required this.items,
    required this.onChanged,
    this.borderRadius = 14,
  });

  final double width;
  final double height;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
  const _StudentsTable({required this.students});

  final List<StudentReport> students;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1138,
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
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            decoration: BoxDecoration(
              color: AppColors.studentsHeaderBackground,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                Text('Students', style: AppTypography.syllabusSectionHeading),
                const Spacer(),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            child: Column(
              children: [
                _TableHeader(),
                const SizedBox(height: 18),
                for (int i = 0; i < students.length; i++) ...[
                  _StudentRowView(student: students[i]),
                  if (i != students.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Divider(height: 1, color: AppColors.studentsTableDivider),
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

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _HeaderCell(label: 'Name', flex: 3),
        _HeaderCell(label: 'Class', flex: 2),
        _HeaderCell(label: 'Attendance %', flex: 2),
        _HeaderCell(label: 'Progress %', flex: 2),
        _HeaderCell(label: 'Performance', flex: 2),
        _HeaderCell(label: 'Status', flex: 2),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.flex});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(label, style: AppTypography.studentsTableHeader),
    );
  }
}

class _StudentRowView extends StatelessWidget {
  const _StudentRowView({required this.student});

  final StudentReport student;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 3, child: Text(student.name, style: AppTypography.studentsTableCell)),
        Expanded(flex: 2, child: Text(student.className, style: AppTypography.studentsTableCell)),
        Expanded(flex: 2, child: Text('${(student.attendance * 100).round()}%', style: AppTypography.studentsTableCell)),
        Expanded(
          flex: 2,
          child: Row(
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
              Text('${(student.progress * 100).round()}%', style: AppTypography.studentsTableCell),
            ],
          ),
        ),
        Expanded(flex: 2, child: _PerformanceLabel(performance: student.performance)),
        Expanded(flex: 2, child: _StatusChip(status: student.status)),
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
    final String label = status == StudentStatus.active ? 'Active' : 'In Active';

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
