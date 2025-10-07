import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class UpcomingTasksTable extends StatelessWidget {
  const UpcomingTasksTable({
    super.key,
    required this.tasks,
  });

  final List<UpcomingTask> tasks;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.summaryCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Upcoming Tasks', style: AppTypography.sectionTitle),
              const Spacer(),
              _StatusFilter(),
            ],
          ),
          const SizedBox(height: 18),
          _TableHeader(),
          const SizedBox(height: 12),
          for (int i = 0; i < tasks.length; i++) ...[
            _TaskRow(tasks[i]),
            if (i != tasks.length - 1)
              const Divider(height: 1, color: AppColors.tableRowDivider),
          ],
        ],
      ),
    );
  }
}

class _StatusFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.summaryCardBorder),
        color: AppColors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: DropdownButton<String>(
            value: 'All',
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textPrimary),
            style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
            onChanged: (_) {},
            items: const [
              DropdownMenuItem(value: 'All', child: Text('All')),
              DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              DropdownMenuItem(value: 'Pending', child: Text('Pending')),
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
    final TextStyle headerStyle = AppTypography.tableHeader;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Task', style: headerStyle)),
          Expanded(flex: 2, child: Text('Class', style: headerStyle)),
          Expanded(flex: 2, child: Text('Date - Time', style: headerStyle)),
          Expanded(
            flex: 2,
            child: Text('Status', style: headerStyle, textAlign: TextAlign.right),
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
    final TextStyle bodyStyle = AppTypography.tableCell;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(_task.task, style: bodyStyle),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _task.className,
              style: AppTypography.tableLink,
            ),
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
