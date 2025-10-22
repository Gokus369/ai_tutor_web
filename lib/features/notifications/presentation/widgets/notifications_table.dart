import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class NotificationsTable extends StatelessWidget {
  const NotificationsTable({
    super.key,
    required this.notifications,
    this.onRowMenuTap,
  });

  final List<NotificationItem> notifications;
  final ValueChanged<NotificationItem>? onRowMenuTap;

  static const double _columnSpacing = 24;
  static const double _actionsWidth = 44;
  static const double _minTableWidth = 980;
  static const double _cardBreakpoint = 720;

  static const List<int> _flex = [20, 12, 20, 12, 12];
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
          return _NotificationCardList(
            notifications: notifications,
            onRowMenuTap: onRowMenuTap,
          );
        }

        final bool needsHorizontalScroll = width < _minTableWidth;
        final double tableWidth =
            needsHorizontalScroll ? _minTableWidth : width;
        final table = _NotificationTableContent(
          notifications: notifications,
          width: tableWidth,
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

class _NotificationTableContent extends StatelessWidget {
  const _NotificationTableContent({
    required this.notifications,
    required this.width,
    this.onRowMenuTap,
  });

  final List<NotificationItem> notifications;
  final double width;
  final ValueChanged<NotificationItem>? onRowMenuTap;

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Text('Notifications',
                  style: AppTypography.syllabusSectionHeading),
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
            for (int i = 0; i < notifications.length; i++) ...[
              _TableRow(
                item: notifications[i],
                onMenuTap: onRowMenuTap,
              ),
              if (i != notifications.length - 1)
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

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    const labels = ['Title', 'Type', 'Sent To', 'Date', 'Status'];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            Expanded(
              flex: NotificationsTable._flex[i],
              child: Align(
                alignment: NotificationsTable._alignment[i],
                child: Text(labels[i], style: AppTypography.tableHeader),
              ),
            ),
            if (i != labels.length - 1) ...[
              const SizedBox(width: NotificationsTable._columnSpacing / 2),
              const _ColumnDivider(),
              const SizedBox(width: NotificationsTable._columnSpacing / 2),
            ],
          ],
          const SizedBox(width: NotificationsTable._columnSpacing / 2),
          const _ColumnDivider(),
          const SizedBox(width: NotificationsTable._columnSpacing / 2),
          const SizedBox(width: NotificationsTable._actionsWidth),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.item,
    this.onMenuTap,
  });

  final NotificationItem item;
  final ValueChanged<NotificationItem>? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final cells = [
      Text(item.title, style: AppTypography.tableCell),
      Text(item.type.label, style: AppTypography.tableCell),
      Text(item.recipient, style: AppTypography.tableCell),
      Text(_formatDate(item.scheduledFor), style: AppTypography.tableCell),
      _StatusChip(status: item.status),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < cells.length; i++) ...[
              Expanded(
                flex: NotificationsTable._flex[i],
                child: Align(
                  alignment: NotificationsTable._alignment[i],
                  child: cells[i],
                ),
              ),
              if (i != cells.length - 1) ...[
                const SizedBox(
                    width: NotificationsTable._columnSpacing / 2),
                const _ColumnDivider(),
                const SizedBox(
                    width: NotificationsTable._columnSpacing / 2),
              ],
            ],
            const SizedBox(width: NotificationsTable._columnSpacing / 2),
            const _ColumnDivider(),
            const SizedBox(width: NotificationsTable._columnSpacing / 2),
            SizedBox(
              width: NotificationsTable._actionsWidth,
              child: IconButton(
                tooltip: 'Notification options',
                onPressed: () => onMenuTap?.call(item),
                icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnDivider extends StatelessWidget {
  const _ColumnDivider();

  @override
  Widget build(BuildContext context) {
    return const VerticalDivider(
      width: 1,
      thickness: 1,
      color: AppColors.studentsTableDivider,
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final NotificationStatus status;

  @override
  Widget build(BuildContext context) {
    final _StatusStyle style = _statusStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(status.label, style: AppTypography.statusChip(style.text)),
    );
  }
}

class _NotificationCardList extends StatelessWidget {
  const _NotificationCardList({
    required this.notifications,
    this.onRowMenuTap,
  });

  final List<NotificationItem> notifications;
  final ValueChanged<NotificationItem>? onRowMenuTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in notifications) ...[
          _NotificationCard(item: item, onMenuTap: onRowMenuTap),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, this.onMenuTap});

  final NotificationItem item;
  final ValueChanged<NotificationItem>? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final _StatusStyle style = _statusStyle(item.status);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
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
                    Text(item.title, style: AppTypography.tableCell),
                    const SizedBox(height: 8),
                    Text(item.type.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Notification options',
                onPressed: () => onMenuTap?.call(item),
                icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.group_outlined,
                  size: 18, color: AppColors.iconMuted),
              const SizedBox(width: 8),
              Text(item.recipient, style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 18, color: AppColors.iconMuted),
              const SizedBox(width: 8),
              Text(_formatDate(item.scheduledFor),
                  style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: style.background,
              borderRadius: BorderRadius.circular(22),
            ),
            child:
                Text(item.status.label, style: AppTypography.statusChip(style.text)),
          ),
        ],
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle({required this.background, required this.text});

  final Color background;
  final Color text;
}

_StatusStyle _statusStyle(NotificationStatus status) {
  switch (status) {
    case NotificationStatus.completed:
      return const _StatusStyle(
        background: AppColors.statusCompletedBackground,
        text: AppColors.statusCompletedText,
      );
    case NotificationStatus.scheduled:
      return const _StatusStyle(
        background: AppColors.statusScheduledBackground,
        text: AppColors.statusScheduledText,
      );
    case NotificationStatus.draft:
      return const _StatusStyle(
        background: AppColors.statusPendingBackground,
        text: AppColors.statusPendingText,
      );
  }
}

String _formatDate(DateTime date) {
  const monthNames = [
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
  final String day = date.day.toString().padLeft(2, '0');
  final String month = monthNames[date.month - 1];
  return '$day $month ${date.year}';
}
