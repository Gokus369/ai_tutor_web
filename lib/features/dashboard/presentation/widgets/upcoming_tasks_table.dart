import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/app_data_table.dart';
import 'package:ai_tutor_web/shared/widgets/status_chip.dart';
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
              else
                AppDataTable(
                  columns: const [
                    AppTableColumn(label: 'Task', flex: 3),
                    AppTableColumn(label: 'Class', flex: 2),
                    AppTableColumn(label: 'Date - Time', flex: 2),
                    AppTableColumn(
                      label: 'Status',
                      flex: 2,
                      alignment: Alignment.centerRight,
                    ),
                  ],
                  rows: tasks
                      .map(
                        (task) => AppTableRowData(
                          cells: [
                            Text(
                              task.task,
                              style: AppTypography.tableCell.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              task.className,
                              style: AppTypography.tableCell.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              _formatDate(task.date),
                              style: AppTypography.tableCell.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            _StatusChip(status: task.status),
                          ],
                        ),
                      )
                      .toList(),
                  showColumnDividers: false,
                  headerPadding: const EdgeInsets.symmetric(horizontal: 24),
                  rowPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  trailingWidth: 0,
                ),
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
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.textPrimary,
            ),
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

String _formatDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  final String year = date.year.toString();
  return '$day-$month-$year';
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

    return AppStatusChip(
      label: label,
      backgroundColor: bgColor,
      textColor: textColor,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      radius: 30,
      textStyle: AppTypography.statusChip(textColor),
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
        border: Border.all(
          color: AppColors.tableRowDivider.withValues(alpha: 0.8),
          width: 0.8,
        ),
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
                  child: Text(
                    task.task,
                    style: AppTypography.sectionTitle.copyWith(fontSize: 16),
                  ),
                ),
                _StatusChip(status: task.status),
              ],
            ),
            const SizedBox(height: 12),
            _MetaRow(
              label: 'Class',
              value: task.className,
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
            const SizedBox(height: 6),
            _MetaRow(
              label: 'Date',
              value: _formatDate(task.date),
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
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
        SizedBox(width: 64, child: Text(label, style: labelStyle)),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: valueStyle)),
      ],
    );
  }
}
