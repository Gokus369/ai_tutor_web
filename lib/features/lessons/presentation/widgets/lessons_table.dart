import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';
import 'package:ai_tutor_web/features/lessons/presentation/utils/lesson_formatters.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class LessonsTable extends StatelessWidget {
  const LessonsTable({
    super.key,
    required this.plans,
    required this.statusFilter,
    required this.onStatusChanged,
    this.onRowMenuTap,
  });

  final List<LessonPlan> plans;
  final LessonStatus? statusFilter;
  final ValueChanged<LessonStatus?> onStatusChanged;
  final ValueChanged<LessonPlan>? onRowMenuTap;

  static const double _columnSpacing = 24;
  static const double _actionsWidth = 44;
  static const double _minTableWidth = 980;
  static const double _cardBreakpoint = 720;

  static const List<int> _flex = [12, 18, 20, 14, 12];
  static const List<Alignment> _alignment = [
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.center,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        if (width < _cardBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _TableHeadingBar(
                  statusFilter: statusFilter,
                  onStatusChanged: onStatusChanged,
                ),
              ),
              _LessonsCardList(plans: plans, onRowMenuTap: onRowMenuTap),
            ],
          );
        }

        final bool needsHorizontalScroll = width < _minTableWidth;
        final double tableWidth = needsHorizontalScroll
            ? _minTableWidth
            : width;
        final table = _LessonsTableContent(
          plans: plans,
          width: tableWidth,
          statusFilter: statusFilter,
          onStatusChanged: onStatusChanged,
          onRowMenuTap: onRowMenuTap,
        );

        if (needsHorizontalScroll) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: tableWidth, child: table),
          );
        }

        return table;
      },
    );
  }
}

class _LessonsTableContent extends StatelessWidget {
  const _LessonsTableContent({
    required this.plans,
    required this.width,
    required this.statusFilter,
    required this.onStatusChanged,
    this.onRowMenuTap,
  });

  final List<LessonPlan> plans;
  final double width;
  final LessonStatus? statusFilter;
  final ValueChanged<LessonStatus?> onStatusChanged;
  final ValueChanged<LessonPlan>? onRowMenuTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: _TableHeadingBar(
                statusFilter: statusFilter,
                onStatusChanged: onStatusChanged,
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.studentsTableDivider,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: _TableHeader(),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: AppColors.studentsTableDivider,
            ),
            for (int i = 0; i < plans.length; i++) ...[
              _TableRow(plan: plans[i], onMenuTap: onRowMenuTap),
              if (i != plans.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.studentsTableDivider,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TableHeadingBar extends StatelessWidget {
  const _TableHeadingBar({
    required this.statusFilter,
    required this.onStatusChanged,
  });

  final LessonStatus? statusFilter;
  final ValueChanged<LessonStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Lessons', style: AppTypography.syllabusSectionHeading),
        const Spacer(),
        _StatusFilterDropdown(
          selected: statusFilter,
          onChanged: onStatusChanged,
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const labels = ['Date', 'Subject', 'Topic', 'Time', 'Status'];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            Expanded(
              flex: LessonsTable._flex[i],
              child: Align(
                alignment: LessonsTable._alignment[i],
                child: Text(
                  labels[i],
                  style: AppTypography.studentsTableHeader,
                ),
              ),
            ),
            if (i != labels.length - 1) ...[
              const SizedBox(width: LessonsTable._columnSpacing / 2),
              const _LessonsColumnDivider(),
              const SizedBox(width: LessonsTable._columnSpacing / 2),
            ],
          ],
          const SizedBox(width: LessonsTable._columnSpacing / 2),
          const _LessonsColumnDivider(),
          const SizedBox(width: LessonsTable._columnSpacing / 2),
          const SizedBox(width: LessonsTable._actionsWidth),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.plan, this.onMenuTap});

  final LessonPlan plan;
  final ValueChanged<LessonPlan>? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells(plan);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < cells.length; i++) ...[
              Expanded(
                flex: LessonsTable._flex[i],
                child: Align(
                  alignment: LessonsTable._alignment[i],
                  child: cells[i],
                ),
              ),
              if (i != cells.length - 1) ...[
                const SizedBox(width: LessonsTable._columnSpacing / 2),
                const _LessonsColumnDivider(),
                const SizedBox(width: LessonsTable._columnSpacing / 2),
              ],
            ],
            const SizedBox(width: LessonsTable._columnSpacing / 2),
            const _LessonsColumnDivider(),
            const SizedBox(width: LessonsTable._columnSpacing / 2),
            SizedBox(
              width: LessonsTable._actionsWidth,
              child: IconButton(
                tooltip: 'Lesson options',
                padding: EdgeInsets.zero,
                splashRadius: 20,
                icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
                onPressed: onMenuTap == null ? null : () => onMenuTap!(plan),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCells(LessonPlan plan) {
    return [
      Text(formatLessonDate(plan.date), style: AppTypography.studentsTableCell),
      Text.rich(
        TextSpan(
          text: '${plan.subject}\n',
          style: AppTypography.studentsTableCell.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
          children: [
            TextSpan(
              text: plan.description,
              style: AppTypography.classCardMeta.copyWith(height: 1.2),
            ),
          ],
        ),
      ),
      Text(plan.topic, style: AppTypography.studentsTableCell),
      Text(
        formatLessonTimeRange(plan.startTime, plan.endTime),
        style: AppTypography.studentsTableCell,
      ),
      _StatusChip(status: plan.status),
    ];
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    final bool completed = status == LessonStatus.completed;
    final Color background = completed
        ? AppColors.statusCompletedBackground
        : AppColors.statusPendingBackground;
    final Color foreground = completed
        ? AppColors.statusCompletedText
        : AppColors.statusPendingText;
    final String label = completed ? 'Completed' : 'Pending';
    final IconData icon =
        completed ? Icons.check_circle_rounded : Icons.schedule_rounded;
    final Color highlight = Color.alphaBlend(
      Colors.white.withValues(alpha: 0.14),
      background,
    );
    final Color depth = Color.alphaBlend(
      AppColors.shadow.withValues(alpha: 0.1),
      background,
    );

    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [highlight, depth],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: background.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: background.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.statusChip(foreground).copyWith(
              color: foreground,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonsColumnDivider extends StatelessWidget {
  const _LessonsColumnDivider();

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

class _LessonsCardList extends StatelessWidget {
  const _LessonsCardList({required this.plans, this.onRowMenuTap});

  final List<LessonPlan> plans;
  final ValueChanged<LessonPlan>? onRowMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < plans.length; i++) ...[
          _LessonCard(plan: plans[i], onMenuTap: onRowMenuTap),
          if (i != plans.length - 1) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({required this.plan, this.onMenuTap});

  final LessonPlan plan;
  final ValueChanged<LessonPlan>? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
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
                      formatLessonDate(plan.date),
                      style: AppTypography.studentsTableCell.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.className,
                      style: AppTypography.classCardMeta.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusChip(status: plan.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            plan.subject,
            style: AppTypography.studentsTableCell.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(plan.description, style: AppTypography.classCardMeta),
          const SizedBox(height: 12),
          Text(plan.topic, style: AppTypography.studentsTableCell),
          const SizedBox(height: 12),
          Text(
            formatLessonTimeRange(plan.startTime, plan.endTime),
            style: AppTypography.classCardMeta.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
              onPressed: onMenuTap == null ? null : () => onMenuTap!(plan),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterDropdown extends StatelessWidget {
  const _StatusFilterDropdown({
    required this.selected,
    required this.onChanged,
  });

  final LessonStatus? selected;
  final ValueChanged<LessonStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.studentsFilterBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.studentsFilterBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<LessonStatus?>(
            value: selected,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textPrimary,
            ),
            style: AppTypography.classCardMeta,
            onChanged: onChanged,
            items: const [
              DropdownMenuItem<LessonStatus?>(value: null, child: Text('All')),
              DropdownMenuItem<LessonStatus?>(
                value: LessonStatus.pending,
                child: Text('Pending'),
              ),
              DropdownMenuItem<LessonStatus?>(
                value: LessonStatus.completed,
                child: Text('Completed'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
