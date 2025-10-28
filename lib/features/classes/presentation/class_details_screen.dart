import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/class_details_demo_data.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

const Color _studentsCardBackground = Color(0xFFFFFFFF);
const Color _studentsHeaderBackground = Color(0xFFEAF2F7);
const Color _studentsHeaderBorder = Color(0xFFD3E4F4);
const Color _studentsRowDivider = Color(0xFFE3EDF7);
const Color _studentsProgressTrack = Color(0xFFD8E5EF);
const Color _studentsProgressValue = Color(0xFF1F5C6E);
const Color _studentsStatusActive = Color(0xFF13B28A);
const Color _studentsStatusInactive = Color(0xFF161A1D);
const Color _studentsActionButtonBorder = Color(0xFFE1ECF5);

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({super.key});

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  final ValueNotifier<_DetailTab> _tab = ValueNotifier<_DetailTab>(_DetailTab.students);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassInfo? info = ModalRoute.of(context)?.settings.arguments as ClassInfo?;
    final String className = info?.name ?? ClassDetailsDemoData.className;

    return DashboardShell(
      activeRoute: AppRoutes.classes,
      builder: (context, shell) {
        final double width = shell.contentWidth;
        return ValueListenableBuilder<_DetailTab>(
          valueListenable: _tab,
          builder: (context, tab, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(className: className),
                const SizedBox(height: 24),
                DashboardSummarySection(
                  metrics: ClassDetailsDemoData.summaries,
                  availableWidth: width,
                ),
                const SizedBox(height: 24),
                _TabSelector(selected: tab, onChanged: (value) => _tab.value = value),
                const SizedBox(height: 24),
                switch (tab) {
                  _DetailTab.students => const _StudentsView(),
                  _DetailTab.syllabus => const _SyllabusView(),
                  _DetailTab.assessments => const _AssessmentsView(),
                },
              ],
            );
          },
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.className});

  final String className;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            className,
            style: AppTypography.dashboardTitle,
          ),
        ),
      ],
    );
  }
}

enum _DetailTab { students, syllabus, assessments }

class _TabSelector extends StatelessWidget {
  const _TabSelector({required this.selected, required this.onChanged});

  final _DetailTab selected;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: _DetailTab.values.map((tab) {
        final bool isActive = tab == selected;
        return ChoiceChip(
          label: Text(
            switch (tab) {
              _DetailTab.students => 'Students',
              _DetailTab.syllabus => 'Syllabus',
              _DetailTab.assessments => 'Assessments',
            },
          ),
          selected: isActive,
          onSelected: (_) => onChanged(tab),
          labelStyle: AppTypography.bodySmall.copyWith(
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isActive ? AppColors.primary : AppColors.studentsCardBorder,
          ),
        );
      }).toList(),
    );
  }
}

class _StudentsView extends StatefulWidget {
  const _StudentsView();

  @override
  State<_StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<_StudentsView> {
  static const double _tableMinWidth = 1240;
  StudentStatus? _statusFilter;

  List<ClassStudentRow> get _students {
    final students = ClassDetailsDemoData.students;
    if (_statusFilter == null) return students;
    return students.where((student) => student.status == _statusFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final students = _students;

    return _ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Students',
                style: AppTypography.sectionTitle.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _StudentsStatusFilter(
                selected: _statusFilter,
                onChanged: (value) => setState(() => _statusFilter = value),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (students.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No students in this status yet.',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                Widget buildTable() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _StudentsHeader(),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          for (int index = 0; index < students.length; index++)
                            _StudentRow(
                              student: students[index],
                              showDivider: index != students.length - 1,
                            ),
                        ],
                      ),
                    ],
                  );
                }

                if (constraints.maxWidth >= _tableMinWidth) {
                  return buildTable();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: _tableMinWidth,
                    child: buildTable(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _StudentsHeader extends StatelessWidget {
  const _StudentsHeader();

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle = AppTypography.studentsTableHeader;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _studentsHeaderBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _studentsHeaderBorder),
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(flex: 24, child: Text('Name', style: headerStyle)),
          const SizedBox(width: 16),
          SizedBox(width: 70, child: Text('Roll No', style: headerStyle)),
          const SizedBox(width: 16),
          SizedBox(width: 110, child: Text('Attendance %', style: headerStyle)),
          const SizedBox(width: 16),
          Expanded(flex: 28, child: Text('Progress %', style: headerStyle)),
          const SizedBox(width: 16),
          SizedBox(width: 220, child: Text('Performance', style: headerStyle)),
          const SizedBox(width: 16),
          SizedBox(width: 120, child: Text('Status', style: headerStyle)),
          const SizedBox(width: 12),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({required this.student, required this.showDivider});

  final ClassStudentRow student;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final TextStyle cellStyle = AppTypography.studentsTableCell;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: _studentsCardBackground,
        border: Border(
          bottom: BorderSide(
            color: showDivider ? _studentsRowDivider : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 24,
            child: Text(student.name, style: cellStyle),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 70,
            child: Text(
              student.rollNo.toString(),
              style: cellStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 110,
            child: Text('${student.attendancePercent}%', style: cellStyle),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 28,
            child: _StudentProgress(progressPercent: student.progressPercent),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 220,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _PerformanceChip(performance: student.performance),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusChip(status: student.status),
            ),
          ),
          const SizedBox(width: 12),
          const _StudentActionsButton(),
        ],
      ),
    );
  }
}

class _StudentProgress extends StatelessWidget {
  const _StudentProgress({required this.progressPercent});

  final int progressPercent;

  @override
  Widget build(BuildContext context) {
    final double fraction = (progressPercent / 100).clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: _studentsProgressTrack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  decoration: BoxDecoration(
                    color: _studentsProgressValue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${progressPercent.clamp(0, 100)}%',
          style: AppTypography.studentsTableCell,
        ),
      ],
    );
  }
}

class _PerformanceChip extends StatelessWidget {
  const _PerformanceChip({required this.performance});

  final StudentPerformance performance;

  @override
  Widget build(BuildContext context) {
    late final String label;
    late final Color color;
    IconData? icon;

    switch (performance) {
      case StudentPerformance.topPerformer:
        label = 'Top Performer';
        color = AppColors.studentsPerformanceTop;
        icon = Icons.star_rounded;
        break;
      case StudentPerformance.average:
        label = 'Average';
        color = AppColors.studentsPerformanceAverage;
        break;
      case StudentPerformance.needAttention:
        label = 'Need Attention';
        color = AppColors.studentsPerformanceAttention;
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        if (icon != null) ...[
          const SizedBox(width: 6),
          Icon(icon, size: 18, color: color),
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
    final bool active = status == StudentStatus.active;
    final Color background = active ? _studentsStatusActive : _studentsStatusInactive;
    final String label = active ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: background,
      ),
      alignment: Alignment.center,
      child: Text(label, style: AppTypography.studentsStatusText),
    );
  }
}

class _StudentActionsButton extends StatelessWidget {
  const _StudentActionsButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _studentsActionButtonBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.more_horiz, color: AppColors.iconMuted, size: 20),
        ),
      ),
    );
  }
}

class _StudentsStatusFilter extends StatelessWidget {
  const _StudentsStatusFilter({
    required this.selected,
    required this.onChanged,
  });

  final StudentStatus? selected;
  final ValueChanged<StudentStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _studentsActionButtonBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<StudentStatus?>(
          value: selected,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textPrimary,
          ),
          isDense: true,
          dropdownColor: Colors.white,
          onChanged: onChanged,
          style: AppTypography.studentsTableCell,
          items: const [
            DropdownMenuItem<StudentStatus?>(
              value: null,
              child: Text('All'),
            ),
            DropdownMenuItem<StudentStatus?>(
              value: StudentStatus.active,
              child: Text('Active'),
            ),
            DropdownMenuItem<StudentStatus?>(
              value: StudentStatus.inactive,
              child: Text('Inactive'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyllabusView extends StatelessWidget {
  const _SyllabusView();

  @override
  Widget build(BuildContext context) {
    final subjects = ClassDetailsDemoData.subjectProgress;
    final overview = ClassDetailsDemoData.progressOverview;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Mathematics', style: AppTypography.sectionTitle),
                const SizedBox(height: 16),
                for (final subject in subjects) ...[
                  _SubjectPanel(subject: subject),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _ContentCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Progress Overview', style: AppTypography.sectionTitle),
                const SizedBox(height: 16),
                for (final item in overview) ...[
                  _ProgressOverviewRow(item: item),
                  const SizedBox(height: 18),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubjectPanel extends StatelessWidget {
  const _SubjectPanel({required this.subject});

  final SubjectProgress subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.studentsCardBorder),
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(subject.subject, style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
              const Spacer(),
              _StatusChip(
                status: subject.overallProgress > 0.6
                    ? StudentStatus.active
                    : StudentStatus.inactive,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final topic in subject.topics) ...[
            Text(topic.title, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _LinearProgress(value: topic.progress),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _LinearProgress extends StatelessWidget {
  const _LinearProgress({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: AppColors.classProgressTrack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0, 1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressOverviewRow extends StatelessWidget {
  const _ProgressOverviewRow({required this.item});

  final ProgressOverview item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(item.subject, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('${(item.completion * 100).round()}%', style: AppTypography.bodySmall),
          ],
        ),
        const SizedBox(height: 6),
        _LinearProgress(value: item.completion),
      ],
    );
  }
}

class _AssessmentsView extends StatelessWidget {
  const _AssessmentsView();

  @override
  Widget build(BuildContext context) {
    final assessments = ClassDetailsDemoData.assessments;

    return _ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Assignments & Assessments', style: AppTypography.sectionTitle),
          const SizedBox(height: 16),
          for (final assessment in assessments) ...[
            _AssessmentCard(assessment: assessment),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _AssessmentCard extends StatelessWidget {
  const _AssessmentCard({required this.assessment});

  final ClassAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final String statusLabel = switch (assessment.status) {
      AssessmentStatus.upcoming => 'Upcoming',
      AssessmentStatus.active => 'Active',
      AssessmentStatus.completed => 'Completed',
    };

    final Color statusColor = switch (assessment.status) {
      AssessmentStatus.upcoming => AppColors.quickActionPurple,
      AssessmentStatus.active => AppColors.quickActionGreen,
      AssessmentStatus.completed => AppColors.accentPink,
    };

    final String typeLabel = switch (assessment.type) {
      AssessmentType.test => 'Test',
      AssessmentType.assignment => 'Assignment',
      AssessmentType.essay => 'Essay',
      AssessmentType.quiz => 'Quiz',
    };

    final String dueLabel = 'Due: ${assessment.dueDate.day} ${_monthName(assessment.dueDate.month)}, ${assessment.dueDate.year}';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(assessment.title, style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(
                      'Submitted: ${assessment.submittedCount}/${assessment.totalCount} students',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(dueLabel, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              _Tag(label: statusLabel, color: statusColor),
            ],
          ),
          const SizedBox(height: 16),
          _Tag(label: typeLabel, color: statusColor.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[(month - 1).clamp(0, 11)];
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _studentsCardBackground,
        border: Border.all(color: AppColors.studentsCardBorder),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
