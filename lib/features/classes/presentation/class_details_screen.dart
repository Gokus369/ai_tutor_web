import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/class_details_demo_data.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

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

class _StudentsView extends StatelessWidget {
  const _StudentsView();

  @override
  Widget build(BuildContext context) {
    final students = ClassDetailsDemoData.students;

    return _ContentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Students', style: AppTypography.sectionTitle),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 28,
              headingTextStyle: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Roll No')),
                DataColumn(label: Text('Attendance %')),
                DataColumn(label: Text('Progress %')),
                DataColumn(label: Text('Performance')),
                DataColumn(label: Text('Status')),
              ],
              rows: [
                for (final student in students)
                  DataRow(
                    cells: [
                      DataCell(Text(student.name)),
                      DataCell(Text(student.rollNo)),
                      DataCell(Text(student.attendance)),
                      DataCell(Text(student.progress)),
                      DataCell(_PerformanceChip(label: student.performance)),
                      DataCell(_StatusChip(status: student.status)),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PerformanceChip extends StatelessWidget {
  const _PerformanceChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.quickActionOrange.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.quickActionOrange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final StudentStatus status;

  @override
  Widget build(BuildContext context) {
    final bool active = status == StudentStatus.active;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active
            ? AppColors.quickActionGreen.withValues(alpha: 0.16)
            : AppColors.accentPink.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'Active' : 'Inactive',
        style: AppTypography.bodySmall.copyWith(
          color: active ? AppColors.quickActionGreen : AppColors.accentPink,
          fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.studentsCardBorder),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
