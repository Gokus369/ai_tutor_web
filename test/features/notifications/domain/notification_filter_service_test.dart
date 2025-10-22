import 'package:ai_tutor_web/features/notifications/domain/models/notification_filters.dart';
import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';
import 'package:ai_tutor_web/features/notifications/domain/services/notification_filter_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = NotificationFilterService();

  final List<NotificationItem> items = [
    NotificationItem(
      title: 'Biology Quiz Reminder',
      type: NotificationType.assignment,
      recipient: 'Class 9D',
      scheduledFor: DateTime(2025, 9, 18),
      status: NotificationStatus.scheduled,
    ),
    NotificationItem(
      title: 'Parent Meeting',
      type: NotificationType.announcement,
      recipient: 'All Parents',
      scheduledFor: DateTime(2025, 9, 12),
      status: NotificationStatus.completed,
    ),
    NotificationItem(
      title: 'Attendance Alert',
      type: NotificationType.alert,
      recipient: 'Class 9B',
      scheduledFor: DateTime(2025, 9, 14),
      status: NotificationStatus.draft,
    ),
  ];

  test('returns notifications sorted by descending scheduled date', () {
    final result = service.apply(
      source: items,
      filters: NotificationFilters.initial(),
    );

    expect(result.map((item) => item.title), const [
      'Biology Quiz Reminder',
      'Attendance Alert',
      'Parent Meeting',
    ]);
  });

  test('applies status, type, and class filters together', () {
    final filters = NotificationFilters.initial().copyWith(
      status: NotificationStatus.completed,
      type: NotificationType.announcement,
      className: 'All Parents',
    );

    final result = service.apply(source: items, filters: filters);

    expect(result, hasLength(1));
    expect(result.first.title, 'Parent Meeting');
  });

  test('matches search query against title and recipient', () {
    final filters = NotificationFilters.initial().copyWith(
      searchQuery: 'class 9',
    );

    final result = service.apply(source: items, filters: filters);

    expect(result.map((item) => item.title), const [
      'Biology Quiz Reminder',
      'Attendance Alert',
    ]);
  });
}
