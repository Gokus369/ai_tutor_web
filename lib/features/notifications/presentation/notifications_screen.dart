import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/notifications/domain/models/notification_filters.dart';
import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';
import 'package:ai_tutor_web/features/notifications/domain/services/notification_filter_service.dart';
import 'package:ai_tutor_web/features/notifications/presentation/widgets/create_notification_dialog.dart';
import 'package:ai_tutor_web/features/notifications/presentation/widgets/notification_filters_bar.dart';
import 'package:ai_tutor_web/features/notifications/presentation/widgets/notifications_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

final List<NotificationItem> _seedNotifications = List.unmodifiable([
  NotificationItem(
    title: 'Homework Reminder – Physics',
    type: NotificationType.assignment,
    recipient: 'Class 9A',
    scheduledFor: DateTime(2025, 9, 5),
    status: NotificationStatus.completed,
  ),
  NotificationItem(
    title: 'Parent Meeting Notice',
    type: NotificationType.announcement,
    recipient: 'All Parents',
    scheduledFor: DateTime(2025, 9, 6),
    status: NotificationStatus.completed,
  ),
  NotificationItem(
    title: 'Low Attendance Alert',
    type: NotificationType.alert,
    recipient: 'Class 9B',
    scheduledFor: DateTime(2025, 9, 8),
    status: NotificationStatus.scheduled,
  ),
  NotificationItem(
    title: 'Quiz Results Available',
    type: NotificationType.assignment,
    recipient: 'Class 10',
    scheduledFor: DateTime(2025, 9, 10),
    status: NotificationStatus.completed,
  ),
  NotificationItem(
    title: 'School Holiday Notice',
    type: NotificationType.announcement,
    recipient: 'All Students',
    scheduledFor: DateTime(2025, 9, 11),
    status: NotificationStatus.scheduled,
  ),
  NotificationItem(
    title: 'Exam Results Available',
    type: NotificationType.announcement,
    recipient: 'Class 8',
    scheduledFor: DateTime(2025, 9, 12),
    status: NotificationStatus.draft,
  ),
  NotificationItem(
    title: 'Homework Reminder – Biology',
    type: NotificationType.assignment,
    recipient: 'Class 9D',
    scheduledFor: DateTime(2025, 9, 16),
    status: NotificationStatus.completed,
  ),
]);

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({
    super.key,
    List<NotificationItem>? initialNotifications,
    NotificationFilterOptions? filterOptions,
    this.filterService = const NotificationFilterService(),
  })  : initialNotifications = initialNotifications ?? _seedNotifications,
        filterOptions = filterOptions ?? NotificationFilterOptions();

  final List<NotificationItem> initialNotifications;
  final NotificationFilterOptions filterOptions;
  final NotificationFilterService filterService;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final TextEditingController _searchController;
  late final List<NotificationItem> _allNotifications;
  late final NotificationFilterService _filterService;

  NotificationFilters _filters = NotificationFilters.initial();

  @override
  void initState() {
    super.initState();
    _allNotifications = List<NotificationItem>.of(widget.initialNotifications);
    _filterService = widget.filterService;
    _searchController = TextEditingController(text: _filters.searchQuery)
      ..addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _updateFilters(
    NotificationFilters Function(NotificationFilters current) transform,
  ) {
    final next = transform(_filters);
    if (next == _filters) return;
    setState(() {
      _filters = next;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    _updateFilters(
      (filters) => filters.copyWith(
        searchQuery: query,
        clearQuery: query.trim().isEmpty,
      ),
    );
  }

  void _handleStatusChanged(NotificationStatus? status) {
    _updateFilters(
      (filters) => filters.copyWith(
        status: status,
        clearStatus: status == null,
      ),
    );
  }

  void _handleTypeChanged(NotificationType? type) {
    _updateFilters(
      (filters) => filters.copyWith(
        type: type,
        clearType: type == null,
      ),
    );
  }

  void _handleClassChanged(String? className) {
    _updateFilters(
      (filters) => filters.copyWith(
        className: className,
        clearClassName: className == null,
      ),
    );
  }

  void _resetFilters() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.text = '';
    _searchController.addListener(_onSearchChanged);
    _updateFilters((_) => NotificationFilters.initial());
  }

  Future<void> _showCreateNotificationDialog(BuildContext context) async {
    final List<String> recipients = _buildRecipientOptions();
    final messenger = ScaffoldMessenger.of(context);

    final CreateNotificationRequest? result =
        await showDialog<CreateNotificationRequest>(
      context: context,
      builder: (dialogContext) => CreateNotificationDialog(
        recipientOptions: recipients,
        initialRecipient: _filters.className,
        initialType: _filters.type ?? NotificationType.assignment,
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _allNotifications.insert(
        0,
        NotificationItem(
          title: result.title,
          type: result.type,
          recipient: result.recipient,
          scheduledFor: DateTime.now(),
          status: NotificationStatus.scheduled,
        ),
      );
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text('Notification "${result.title}" created'),
      ),
    );
  }

  List<String> _buildRecipientOptions() {
    final List<String> options = [];
    final Set<String> seen = {};

    for (final option in widget.filterOptions.classroomOptions) {
      final String candidate =
          (option.value ?? option.label).trim();
      if (candidate.isEmpty || seen.contains(candidate)) continue;
      seen.add(candidate);
      options.add(candidate);
    }

    final String? currentSelection = _filters.className?.trim();
    if (currentSelection != null &&
        currentSelection.isNotEmpty &&
        !seen.contains(currentSelection)) {
      options.insert(0, currentSelection);
      seen.add(currentSelection);
    }

    if (options.isEmpty) {
      options.add('All Students');
    }

    return options;
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.notifications,
      builder: (context, shell) {
        final bool isCompactFilters = shell.contentWidth < 980;
        final notifications = _filterService.apply(
          source: _allNotifications,
          filters: _filters,
        );
        final filterOptions = widget.filterOptions;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Notifications', style: AppTypography.dashboardTitle),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showCreateNotificationDialog(context),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Create Notifications'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            NotificationFiltersBar(
              isCompact: isCompactFilters,
              searchController: _searchController,
              statusOptions: filterOptions.statusOptions,
              selectedStatus: _filters.status,
              onStatusChanged: _handleStatusChanged,
              typeOptions: filterOptions.typeOptions,
              selectedType: _filters.type,
              onTypeChanged: _handleTypeChanged,
              classOptions: filterOptions.classroomOptions,
              selectedClass: _filters.className,
              onClassChanged: _handleClassChanged,
            ),
            const SizedBox(height: 24),
            if (notifications.isEmpty)
              _EmptyState(onClearFilters: _resetFilters)
            else
              NotificationsTable(
                notifications: notifications,
                onRowMenuTap: (item) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Options tapped for "${item.title}"'),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      decoration: BoxDecoration(
        color: AppColors.studentsCardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.notifications_none,
            size: 48,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications found',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or reset to see all notifications.',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onClearFilters,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size(0, 42),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('Reset Filters'),
          ),
        ],
      ),
    );
  }
}
