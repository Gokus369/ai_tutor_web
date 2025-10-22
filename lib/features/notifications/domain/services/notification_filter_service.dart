import 'package:ai_tutor_web/features/notifications/domain/models/notification_filters.dart';
import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';

class NotificationFilterService {
  const NotificationFilterService();

  List<NotificationItem> apply({
    required List<NotificationItem> source,
    required NotificationFilters filters,
  }) {
    final String query = filters.searchQuery.trim().toLowerCase();

    final result = source.where((item) {
      final matchesQuery = !filters.hasQuery ||
          item.title.toLowerCase().contains(query) ||
          item.recipient.toLowerCase().contains(query);
      final matchesStatus =
          filters.status == null || item.status == filters.status;
      final matchesType = filters.type == null || item.type == filters.type;
      final matchesClass =
          filters.className == null || item.recipient == filters.className;

      return matchesQuery && matchesStatus && matchesType && matchesClass;
    }).toList()
      ..sort(NotificationItem.compareByDateDescending);

    return result;
  }
}
