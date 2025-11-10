import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class UpcomingTasksTable extends StatelessWidget {
  const UpcomingTasksTable({
    super.key,
    required this.tasks,
    this.compact = false,
  });

  final List<UpcomingTask> tasks;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool useCompact = compact || constraints.maxWidth < 640;

        return Container(
          padding: EdgeInsets.fromLTRB(
            useCompact ? 20 : 28,
            useCompact ? 24 : 28,
            useCompact ? 20 : 28,
            useCompact ? 20 : 18,
          ),
          decoration: BoxDecoration(
            color: AppColors.tableRowBackground,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: AppColors.summaryCardBorder, width: 1),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Upcoming Tasks',
                      style: AppTypography.sectionTitle,
                    ),
                  ),
                  _StatusFilter(),
                ],
              ),
              const SizedBox(height: 20),
              if (useCompact)
                Column(
                  children: [
                    for (int i = 0; i < tasks.length; i++) ...[
                      _CompactTaskCard(tasks[i]),
                      if (i != tasks.length - 1) const SizedBox(height: 12),
                    ],
                  ],
                )
              else ...[
                _TableHeader(),
                const SizedBox(height: 6),
                for (int i = 0; i < tasks.length; i++) ...[
                  _TaskRow(tasks[i]),
                  if (i != tasks.length - 1)
                    const Divider(height: 1, thickness: 0.6, color: AppColors.tableRowDivider),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatusFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.summaryCardBorder),
        color: AppColors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: SizedBox(
          height: 28,
          width: 110,
          child: DropdownButton<String>(
            value: 'All',
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textPrimary),
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            underline: const SizedBox.shrink(),
            onChanged: (_) {},
            items: const [
              DropdownMenuItem(
                value: 'All',
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('All'),
                ),
              ),
              DropdownMenuItem(
                value: 'Completed',
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Completed'),
                ),
              ),
              DropdownMenuItem(
                value: 'Pending',
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Pending'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.tableRowDivider, width: 0.6),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Task',
              style: AppTypography.tableHeader.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Class',
              style: AppTypography.tableHeader.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date - Time',
              style: AppTypography.tableHeader.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: AppTypography.tableHeader.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow(UpcomingTask task) : _task = task;

  final UpcomingTask _task;

  @override
  Widget build(BuildContext context) {
    final TextStyle bodyStyle = AppTypography.tableCell.copyWith(color: AppColors.textPrimary);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(_task.task, style: bodyStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(_task.className, style: bodyStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(_formatDate(_task.date), style: bodyStyle),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: _StatusChip(status: _task.status),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day-$month-$year';
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color bgColor;
    late final Color textColor;
    late final String label;

    switch (status) {
      case TaskStatus.completed:
        bgColor = AppColors.statusCompletedBackground;
        textColor = AppColors.statusCompletedText;
        label = 'Completed';
        break;
      case TaskStatus.pending:
        bgColor = AppColors.statusPendingBackground;
        textColor = AppColors.statusPendingText;
        label = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(label, style: AppTypography.statusChip(textColor)),
    );
  }
}

class _CompactTaskCard extends StatelessWidget {
  const _CompactTaskCard(this.task);

  final UpcomingTask task;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = AppTypography.tableCell.copyWith(
      color: AppColors.textMuted,
      fontSize: 13,
    );
    final TextStyle valueStyle = AppTypography.tableCell.copyWith(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.tableRowDivider.withValues(alpha: 0.8), width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(task.task, style: AppTypography.sectionTitle.copyWith(fontSize: 16)),
                ),
                _StatusChip(status: task.status),
              ],
            ),
            const SizedBox(height: 12),
            _MetaRow(label: 'Class', value: task.className, labelStyle: labelStyle, valueStyle: valueStyle),
            const SizedBox(height: 6),
            _MetaRow(label: 'Date', value: _formatDate(task.date), labelStyle: labelStyle, valueStyle: valueStyle),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day-$month-$year';
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
        SizedBox(width: 64, child: Text(label, style: labelStyle)),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: valueStyle)),
      ],
    );
  }
}
