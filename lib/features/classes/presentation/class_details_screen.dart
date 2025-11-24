import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/class_details_demo_data.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

const Color _studentsRowDivider = Color(0xFFE3EDF7);
const Color _studentsProgressTrack = Color(0xFFD8E5EF);
const Color _studentsProgressValue = Color(0xFF1F5C6E);
const Color _studentsStatusActive = Color(0xFF13B28A);
const Color _studentsStatusInactive = Color(0xFF161A1D);
const Color _studentsActionButtonBorder = Color(0xFFE1ECF5);
const Color _syllabusCollapsedBorder = AppColors.studentsCardBorder;

class ClassDetailsScreen extends StatefulWidget {
  const ClassDetailsScreen({super.key, this.initialInfo});

  final ClassInfo? initialInfo;

  @override
  State<ClassDetailsScreen> createState() => _ClassDetailsScreenState();
}

class _ClassDetailsScreenState extends State<ClassDetailsScreen> {
  final ValueNotifier<_DetailTab> _tab = ValueNotifier<_DetailTab>(
    _DetailTab.students,
  );

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ClassInfo? info =
        widget.initialInfo ??
        ModalRoute.of(context)?.settings.arguments as ClassInfo?;
    final String className = info?.name ?? ClassDetailsDemoData.className;

    return DashboardPage(
      activeRoute: AppRoutes.classes,
      title: className,
      builder: (context, shell) {
        final double width = shell.contentWidth;
        return ValueListenableBuilder<_DetailTab>(
          valueListenable: _tab,
          builder: (context, tab, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DashboardSummarySection(
                  metrics: ClassDetailsDemoData.summaries,
                  availableWidth: width,
                ),
                const SizedBox(height: 24),
                _TabSelector(
                  selected: tab,
                  onChanged: (value) => _tab.value = value,
                ),
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
          label: Text(switch (tab) {
            _DetailTab.students => 'Students',
            _DetailTab.syllabus => 'Syllabus',
            _DetailTab.assessments => 'Assessments',
          }),
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
  static const double _tableMinWidth = 960;
  StudentStatus? _statusFilter;

  List<ClassStudentRow> get _students {
    final students = ClassDetailsDemoData.students;
    if (_statusFilter == null) return students;
    return students
        .where((student) => student.status == _statusFilter)
        .toList();
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
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x140F2236),
                          blurRadius: 28,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _StudentsHeader(),
                          for (int index = 0; index < students.length; index++)
                            _StudentRow(
                              student: students[index],
                              showDivider: index != students.length - 1,
                            ),
                        ],
                      ),
                    ),
                  );
                }

                if (constraints.maxWidth >= _tableMinWidth) {
                  return buildTable();
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(width: _tableMinWidth, child: buildTable()),
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
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: Color(0xFFEFF4F8),
        border: Border(
          bottom: BorderSide(color: _studentsRowDivider, width: 1),
        ),
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
          SizedBox(width: 180, child: Text('Performance', style: headerStyle)),
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
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Expanded(flex: 24, child: Text(student.name, style: cellStyle)),
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
          const SizedBox(width: 36, child: _StudentActionsButton()),
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
        Expanded(child: _ProgressBar(value: fraction)),
        const SizedBox(width: 12),
        Text(
          '${progressPercent.clamp(0, 100)}%',
          style: AppTypography.studentsTableCell.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
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
    final Color background = active
        ? _studentsStatusActive
        : _studentsStatusInactive;
    final String label = active ? 'Active' : 'Inactive';

    return Container(
      height: 27,
      constraints: const BoxConstraints(minWidth: 93),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
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
          child: const Icon(
            Icons.more_horiz,
            color: AppColors.iconMuted,
            size: 20,
          ),
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
            DropdownMenuItem<StudentStatus?>(value: null, child: Text('All')),
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

class _SyllabusView extends StatefulWidget {
  const _SyllabusView();

  @override
  State<_SyllabusView> createState() => _SyllabusViewState();
}

class _SyllabusViewState extends State<_SyllabusView> {
  late String _expandedSubjectId;
  late Map<String, Set<String>> _expandedModules;

  @override
  void initState() {
    super.initState();
    final subjects = ClassDetailsDemoData.syllabusSubjects;
    _expandedSubjectId = subjects.isNotEmpty ? subjects.first.id : '';
    _expandedModules = {
      for (final subject in subjects)
        subject.id:
            subject.modules.isNotEmpty && subject.id == _expandedSubjectId
            ? {subject.modules.first.id}
            : <String>{},
    };
  }

  void _handleSubjectToggle(String subjectId) {
    setState(() {
      _expandedSubjectId = subjectId;
      final subject = ClassDetailsDemoData.syllabusSubjects.firstWhere(
        (element) => element.id == subjectId,
        orElse: () => ClassDetailsDemoData.syllabusSubjects.first,
      );
      if (subject.modules.isNotEmpty) {
        final current = _expandedModules[subjectId];
        if (current == null || current.isEmpty) {
          _expandedModules[subjectId] = {subject.modules.first.id};
        }
      }
    });
  }

  void _handleModuleToggle(String subjectId, String moduleId) {
    setState(() {
      final Set<String> current = _expandedModules[subjectId] ?? <String>{};
      if (current.contains(moduleId)) {
        current.remove(moduleId);
      } else {
        current.add(moduleId);
      }
      _expandedModules[subjectId] = {...current};
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjects = ClassDetailsDemoData.syllabusSubjects;
    final overview = ClassDetailsDemoData.progressOverview;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isStacked = constraints.maxWidth < 1000;
        final syllabusCard = _SyllabusSubjectsCard(
          subjects: subjects,
          expandedSubjectId: _expandedSubjectId,
          expandedModules: _expandedModules,
          onSubjectChanged: _handleSubjectToggle,
          onModuleToggle: _handleModuleToggle,
        );
        final overviewCard = _ProgressOverviewCard(items: overview);

        if (isStacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              syllabusCard,
              const SizedBox(height: 24),
              overviewCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 2, child: syllabusCard),
            const SizedBox(width: 24),
            Expanded(child: overviewCard),
          ],
        );
      },
    );
  }
}

class _SyllabusSubjectsCard extends StatelessWidget {
  const _SyllabusSubjectsCard({
    required this.subjects,
    required this.expandedSubjectId,
    required this.expandedModules,
    required this.onSubjectChanged,
    required this.onModuleToggle,
  });

  final List<SyllabusSubject> subjects;
  final String expandedSubjectId;
  final Map<String, Set<String>> expandedModules;
  final ValueChanged<String> onSubjectChanged;
  final void Function(String subjectId, String moduleId) onModuleToggle;

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.studentsCardBorder),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          'No syllabus data available.',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < subjects.length; index++) ...[
          _SubjectAccordion(
            subject: subjects[index],
            isExpanded: subjects[index].id == expandedSubjectId,
            expandedModules:
                expandedModules[subjects[index].id] ?? const <String>{},
            onSubjectSelected: () => onSubjectChanged(subjects[index].id),
            onModuleToggle: (moduleId) =>
                onModuleToggle(subjects[index].id, moduleId),
          ),
          if (index != subjects.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _SubjectAccordion extends StatelessWidget {
  const _SubjectAccordion({
    required this.subject,
    required this.isExpanded,
    required this.expandedModules,
    required this.onSubjectSelected,
    required this.onModuleToggle,
  });

  final SyllabusSubject subject;
  final bool isExpanded;
  final Set<String> expandedModules;
  final VoidCallback onSubjectSelected;
  final ValueChanged<String> onModuleToggle;

  @override
  Widget build(BuildContext context) {
    final bool hasModules = subject.modules.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isExpanded
                  ? AppColors.studentsCardBorder
                  : _syllabusCollapsedBorder,
            ),
            boxShadow: isExpanded
                ? const [
                    BoxShadow(
                      color: Color(0x11000000),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            subject.title,
                            style:
                                AppTypography.sectionTitle.copyWith(fontSize: 18),
                          ),
                          _SyllabusStatusChip(status: subject.status),
                        ],
                      ),
                    ),
                    if (hasModules)
                      IconButton(
                        onPressed: onSubjectSelected,
                        icon: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: AppColors.textPrimary,
                        ),
                      ),
                  ],
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 24,
                    right: 24,
                    bottom: 20,
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < subject.modules.length; i++) ...[
                        _ModuleCard(
                          module: subject.modules[i],
                          isExpanded: expandedModules.contains(
                            subject.modules[i].id,
                          ),
                          onToggle: () => onModuleToggle(subject.modules[i].id),
                        ),
                        if (i != subject.modules.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
                crossFadeState: isExpanded && hasModules
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SyllabusStatusChip extends StatelessWidget {
  const _SyllabusStatusChip({required this.status});

  final SyllabusStatus status;

  @override
  Widget build(BuildContext context) {
    final bool completed = status == SyllabusStatus.completed;
    final Color baseColor = completed
        ? AppColors.quickActionGreen
        : AppColors.accentOrange;
    final String label = completed ? 'Completed' : 'Inprogress';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.module,
    required this.isExpanded,
    required this.onToggle,
  });

  final SyllabusModule module;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final bool hasTopics = module.topics.isNotEmpty;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.studentsCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    module.title,
                    style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: onToggle,
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: AppColors.studentsCardBorder),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: hasTopics
                  ? Column(
                      children: [
                        for (int i = 0; i < module.topics.length; i++) ...[
                          _ModuleTopicRow(topic: module.topics[i]),
                          if (i != module.topics.length - 1)
                            const SizedBox(height: 18),
                        ],
                      ],
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Topics coming soon',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ModuleTopicRow extends StatelessWidget {
  const _ModuleTopicRow({required this.topic});

  final SyllabusTopic topic;

  @override
  Widget build(BuildContext context) {
    final int percent = (topic.progress * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.studentsCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  topic.title,
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.iconMuted,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _ProgressBar(value: topic.progress)),
              const SizedBox(width: 12),
              Text(
                '$percent%',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressOverviewCard extends StatelessWidget {
  const _ProgressOverviewCard({required this.items});

  final List<ProgressOverview> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.studentsCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Progress Overview', style: AppTypography.sectionTitle),
          const SizedBox(height: 16),
          for (int i = 0; i < items.length; i++) ...[
            _ProgressOverviewEntry(item: items[i]),
            if (i != items.length - 1) const SizedBox(height: 18),
          ],
        ],
      ),
    );
  }
}

class _ProgressOverviewEntry extends StatelessWidget {
  const _ProgressOverviewEntry({required this.item});

  final ProgressOverview item;

  @override
  Widget build(BuildContext context) {
    final int percent = (item.completion * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.subject,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text('$percent%', style: AppTypography.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        _ProgressBar(value: item.completion),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      decoration: BoxDecoration(
        color: _studentsProgressTrack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: _studentsProgressValue,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
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

    final String dueLabel =
        'Due: ${assessment.dueDate.day} ${_monthName(assessment.dueDate.month)}, ${assessment.dueDate.year}';

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
                    Text(
                      assessment.title,
                      style: AppTypography.sectionTitle.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Submitted: ${assessment.submittedCount}/${assessment.totalCount} students',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F2236),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}
