import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

/// High level view of syllabus progress and individual student performance.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const List<String> _classOptions = ['Class 10', 'Class 9', 'Class 8'];

  final TextEditingController _searchController = TextEditingController();
  _ProgressView _activeView = _ProgressView.modules;
  final List<_StudentProgress> _students = const [
    _StudentProgress(name: 'Rowan Hahn', progress: 0.85),
    _StudentProgress(name: 'Giovanni Fields', progress: 0.46),
    _StudentProgress(name: 'Rowen Holland', progress: 0.58),
    _StudentProgress(name: 'Celeste Moore', progress: 0.52),
    _StudentProgress(
      name: 'Matteo Nelson',
      progress: 0.79,
      alert: _StudentAlert(
        label: 'Struggling in Maths',
        type: _AlertType.warning,
      ),
    ),
    _StudentProgress(
      name: 'Elise Gill',
      progress: 0.30,
      alert: _StudentAlert(label: 'Low Performance', type: _AlertType.danger),
    ),
    _StudentProgress(name: 'Gerardo Dillon', progress: 0.33),
  ];

  String _selectedClass = _classOptions.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_StudentProgress> get _filteredStudents {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _students;
    return _students
        .where((student) => student.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.progress,
      builder: (context, shell) {
        final double contentWidth = shell.contentWidth;
        final double resolvedWidth = contentWidth >= 1200 ? 1200 : contentWidth;
        final bool compact = resolvedWidth < 960;
        final double cardPadding = compact ? 24 : 32;

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: resolvedWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Progress', style: AppTypography.dashboardTitle),
                const SizedBox(height: 24),
                _ProgressSummaryCard(
                  padding: cardPadding,
                  compact: compact,
                  classOptions: _classOptions,
                  selectedClass: _selectedClass,
                  view: _activeView,
                  onClassChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedClass = value);
                  },
                  onViewChanged: (view) {
                    if (view == _activeView) return;
                    setState(() => _activeView = view);
                  },
                  searchController: _searchController,
                  onSearchChanged: (_) => setState(() {}),
                  totalStudents: _students.length,
                  modulesCount: 24,
                ),
                const SizedBox(height: 28),
                if (_activeView == _ProgressView.modules) ...[
                  _MathematicsProgressCard(
                    padding: cardPadding,
                    compact: compact,
                  ),
                  const SizedBox(height: 24),
                  _AdditionalSubjectsCard(
                    padding: cardPadding,
                    compact: compact,
                  ),
                ] else
                  _StudentsProgressCard(
                    padding: cardPadding,
                    compact: compact,
                    students: _filteredStudents,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

enum _ProgressView { modules, students }

class _ProgressSummaryCard extends StatelessWidget {
  const _ProgressSummaryCard({
    required this.padding,
    required this.compact,
    required this.classOptions,
    required this.selectedClass,
    required this.view,
    required this.onClassChanged,
    required this.onViewChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.totalStudents,
    required this.modulesCount,
  });

  final double padding;
  final bool compact;
  final List<String> classOptions;
  final String selectedClass;
  final _ProgressView view;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<_ProgressView> onViewChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final int totalStudents;
  final int modulesCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding * 0.75),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.progressCardBorder, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 32,
          ),
        ],
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
                      'Progress Overview',
                      style: AppTypography.sectionTitle.copyWith(
                        fontSize: compact ? 22 : 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _MetricChip(label: 'Modules', value: '$modulesCount'),
                        _MetricChip(label: 'Students', value: '$totalStudents'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(
                width: compact ? 280 : 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(selectedClass),
                        initialValue: selectedClass,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          filled: true,
                          fillColor: AppColors.syllabusSearchBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.sidebarBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: AppColors.sidebarBorder,
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 24,
                        ),
                        items: classOptions
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: onClassChanged,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: AppTypography.button,
                        ),
                        icon: const Icon(Icons.file_upload_outlined, size: 20),
                        label: const Text('Export Report'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _ViewToggleChip(
                label: 'Modules',
                active: view == _ProgressView.modules,
                onTap: () => onViewChanged(_ProgressView.modules),
              ),
              const SizedBox(width: 12),
              _ViewToggleChip(
                label: 'Students',
                active: view == _ProgressView.students,
                onTap: () => onViewChanged(_ProgressView.students),
              ),
            ],
          ),
          if (view == _ProgressView.students) ...[
            const SizedBox(height: 28),
            SizedBox(
              height: 64,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  hintText: 'Search students',
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: AppColors.greyMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: AppColors.syllabusSearchBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: AppColors.sidebarBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: AppColors.sidebarBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
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

class _MathematicsProgressCard extends StatelessWidget {
  const _MathematicsProgressCard({
    required this.padding,
    required this.compact,
  });

  final double padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets outerPadding = EdgeInsets.symmetric(
      horizontal: padding,
      vertical: padding,
    );

    return Container(
      padding: outerPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.progressCardBorder, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MathematicsSection(compact: compact),
          const SizedBox(height: 20),
          _CollapsedSubjectTile(title: 'Geometry', compact: compact),
          const SizedBox(height: 14),
          _CollapsedSubjectTile(title: 'Algebra', compact: compact),
        ],
      ),
    );
  }
}

class _AdditionalSubjectsCard extends StatelessWidget {
  const _AdditionalSubjectsCard({required this.padding, required this.compact});

  final double padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.progressCardBorder, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SubjectSummaryRow(
            subject: 'Physics',
            status: _SubjectStatus.inProgress,
            compact: compact,
          ),
          const SizedBox(height: 18),
          _SubjectSummaryRow(
            subject: 'English',
            status: _SubjectStatus.inProgress,
            compact: compact,
          ),
          const SizedBox(height: 18),
          _SubjectSummaryRow(
            subject: 'Social Science',
            status: _SubjectStatus.completed,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _MathematicsSection extends StatelessWidget {
  const _MathematicsSection({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final TextStyle heading = AppTypography.sectionTitle.copyWith(
      fontSize: compact ? 22 : 24,
      fontWeight: FontWeight.w700,
      color: AppColors.primary,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.progressSectionBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.progressSectionBorder),
      ),
      padding: compact
          ? const EdgeInsets.fromLTRB(22, 24, 22, 28)
          : const EdgeInsets.fromLTRB(28, 28, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Mathematics', style: heading),
                    const SizedBox(width: 12),
                    const _StatusChip(status: _SubjectStatus.inProgress),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                splashRadius: 20,
                icon: const Icon(Icons.keyboard_arrow_up, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Linear Equations',
            style: AppTypography.metricLabel.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          const _ChapterProgressTile(
            title: 'Chapter 1: Linear Equations (10/15 Topics)',
            progress: 0.62,
            progressLabel: '62%',
          ),
          const SizedBox(height: 18),
          const _ChapterProgressTile(
            title: 'Chapter 2: Function & Graphs (5/8 Topics)',
            progress: 0.46,
            progressLabel: '46%',
          ),
          const SizedBox(height: 18),
          const _ChapterProgressTile(
            title: 'Chapter 3: Variables and Constants (5/10 Topics)',
            progress: 0.77,
            progressLabel: '77%',
          ),
        ],
      ),
    );
  }
}

class _ChapterProgressTile extends StatelessWidget {
  const _ChapterProgressTile({
    required this.title,
    required this.progress,
    required this.progressLabel,
  });

  final String title;
  final double progress;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.progressModuleBorder),
      ),
      constraints: const BoxConstraints(minHeight: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.metricLabel.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                progressLabel,
                style: AppTypography.metricLabel.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                splashRadius: 18,
                icon: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double filled = constraints.maxWidth * progress;
              return Stack(
                children: [
                  Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.progressMetricTrack,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    width: filled,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CollapsedSubjectTile extends StatelessWidget {
  const _CollapsedSubjectTile({required this.title, required this.compact});

  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: EdgeInsets.symmetric(horizontal: compact ? 20 : 24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.progressSectionBorder, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTypography.metricLabel.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
        ],
      ),
    );
  }
}

class _SubjectSummaryRow extends StatelessWidget {
  const _SubjectSummaryRow({
    required this.subject,
    required this.status,
    required this.compact,
  });

  final String subject;
  final _SubjectStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 86 : 90,
      padding: EdgeInsets.symmetric(horizontal: compact ? 22 : 28),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.progressSectionBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subject,
              style: AppTypography.sectionTitle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          _StatusChip(status: status),
          const SizedBox(width: 18),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 26),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final _SubjectStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;
    late final String label;

    switch (status) {
      case _SubjectStatus.inProgress:
        background = AppColors.syllabusStatusInProgress;
        foreground = AppColors.syllabusStatusText;
        label = 'Inprogress';
        break;
      case _SubjectStatus.completed:
        background = AppColors.statusCompletedBackground;
        foreground = AppColors.statusCompletedText;
        label = 'Completed';
        break;
    }

    return Container(
      height: 27,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(label, style: AppTypography.statusChip(foreground)),
    );
  }
}

enum _SubjectStatus { inProgress, completed }

class _StudentsProgressCard extends StatelessWidget {
  const _StudentsProgressCard({
    required this.padding,
    required this.compact,
    required this.students,
  });

  final double padding;
  final bool compact;
  final List<_StudentProgress> students;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.progressCardBorder, width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 10),
            blurRadius: 32,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Students',
            style: AppTypography.sectionTitle.copyWith(
              fontSize: compact ? 20 : 22,
            ),
          ),
          const SizedBox(height: 14),
          _StudentsTableHeader(compact: compact),
          const SizedBox(height: 4),
          for (int i = 0; i < students.length; i++)
            _StudentRow(
              student: students[i],
              compact: compact,
              last: i == students.length - 1,
            ),
        ],
      ),
    );
  }
}

class _StudentsTableHeader extends StatelessWidget {
  const _StudentsTableHeader({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22),
      decoration: BoxDecoration(
        color: AppColors.progressSectionBackground,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Name',
              style: AppTypography.metricLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const _HeaderDivider(),
          Expanded(
            flex: 3,
            child: Text(
              'Progress %',
              style: AppTypography.metricLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const _HeaderDivider(offset: 18),
          Expanded(
            flex: 3,
            child: Text(
              'Alert',
              style: AppTypography.metricLabel.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}

class _StudentRow extends StatelessWidget {
  const _StudentRow({
    required this.student,
    required this.compact,
    required this.last,
  });

  final _StudentProgress student;
  final bool compact;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 16 : 22,
            vertical: 14,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  student.name,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              _RowDivider(compact: compact, offset: 12),
              Expanded(
                flex: 3,
                child: _ProgressCell(value: student.progress, compact: compact),
              ),
              _RowDivider(compact: compact, offset: 12),
              Expanded(flex: 3, child: _AlertCell(alert: student.alert)),
              const SizedBox(width: 24),
              IconButton(
                onPressed: () {},
                splashRadius: 18,
                icon: const Icon(Icons.more_horiz, size: 20),
              ),
            ],
          ),
        ),
        if (!last)
          Divider(
            height: 1,
            thickness: 1,
            indent: compact ? 16 : 22,
            endIndent: compact ? 16 : 22,
            color: AppColors.progressSectionBorder.withValues(alpha: 0.55),
          ),
      ],
    );
  }
}

class _ProgressCell extends StatelessWidget {
  const _ProgressCell({required this.value, required this.compact});

  final double value;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final String percentage = '${(value * 100).round()}%';
    final double ratio = value.clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: compact ? 6 : 8,
            decoration: BoxDecoration(
              color: AppColors.progressMetricTrack,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          percentage,
          style: AppTypography.metricLabel.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _ViewToggleChip extends StatelessWidget {
  const _ViewToggleChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = active ? AppColors.primary : AppColors.white;
    final Color border = active
        ? AppColors.primary
        : AppColors.progressChipBorder;
    final Color foreground = active ? AppColors.white : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.progressChipBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.progressChipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.metricValue.copyWith(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCell extends StatelessWidget {
  const _AlertCell({this.alert});

  final _StudentAlert? alert;

  @override
  Widget build(BuildContext context) {
    if (alert == null) {
      return Text(
        '-',
        style: AppTypography.bodySmall.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.greyMuted,
        ),
      );
    }

    Color color;
    switch (alert!.type) {
      case _AlertType.warning:
        color = AppColors.statusPendingBackground;
        break;
      case _AlertType.danger:
        color = AppColors.statusErrorBackground;
        break;
    }

    return Text(
      alert!.label,
      style: AppTypography.bodySmall.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _HeaderDivider extends StatelessWidget {
  const _HeaderDivider({this.offset});

  final double? offset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: EdgeInsets.symmetric(horizontal: offset ?? 14),
      color: AppColors.progressSectionBorder.withValues(alpha: 0.6),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider({required this.compact, required int offset});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: compact ? 24 : 28,
      margin: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
      color: AppColors.progressSectionBorder.withValues(alpha: 0.4),
    );
  }
}

class _StudentProgress {
  const _StudentProgress({
    required this.name,
    required this.progress,
    this.alert,
  });

  final String name;
  final double progress;
  final _StudentAlert? alert;
}

class _StudentAlert {
  const _StudentAlert({required this.label, required this.type});

  final String label;
  final _AlertType type;
}

enum _AlertType { warning, danger }
