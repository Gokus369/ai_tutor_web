import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';

/// Immutable representation of the filters available on the notifications view.
class NotificationFilters {
  const NotificationFilters({
    this.searchQuery = '',
    this.status,
    this.type,
    this.className,
  });

  factory NotificationFilters.initial() => const NotificationFilters();

  final String searchQuery;
  final NotificationStatus? status;
  final NotificationType? type;
  final String? className;

  bool get hasQuery => searchQuery.trim().isNotEmpty;

  NotificationFilters copyWith({
    String? searchQuery,
    bool clearQuery = false,
    NotificationStatus? status,
    bool clearStatus = false,
    NotificationType? type,
    bool clearType = false,
    String? className,
    bool clearClassName = false,
  }) {
    return NotificationFilters(
      searchQuery: clearQuery ? '' : (searchQuery ?? this.searchQuery),
      status: clearStatus ? null : (status ?? this.status),
      type: clearType ? null : (type ?? this.type),
      className: clearClassName ? null : (className ?? this.className),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationFilters &&
        other.searchQuery == searchQuery &&
        other.status == status &&
        other.type == type &&
        other.className == className;
  }

  @override
  int get hashCode =>
      Object.hash(searchQuery, status, type, className);

  @override
  String toString() {
    return 'NotificationFilters(query: "$searchQuery", status: $status, type: $type, className: $className)';
  }
}

/// Simple struct used to render dropdown options in a type-safe manner.
class FilterOption<T> {
  const FilterOption({
    required this.label,
    this.value,
  });

  final String label;
  final T? value;
}

class NotificationFilterOptions {
  const NotificationFilterOptions({
    this.classroomOptions = const [
      FilterOption<String>(label: 'All Classes'),
      FilterOption<String>(label: 'Class 9A', value: 'Class 9A'),
      FilterOption<String>(label: 'Class 9B', value: 'Class 9B'),
      FilterOption<String>(label: 'Class 10', value: 'Class 10'),
      FilterOption<String>(label: 'Class 8', value: 'Class 8'),
      FilterOption<String>(label: 'Class 9D', value: 'Class 9D'),
      FilterOption<String>(label: 'All Parents', value: 'All Parents'),
      FilterOption<String>(label: 'All Students', value: 'All Students'),
    ],
  });

  final List<FilterOption<String>> classroomOptions;

  List<FilterOption<NotificationStatus>> get statusOptions => [
        const FilterOption<NotificationStatus>(label: 'All Status'),
        ...NotificationStatus.values
            .map((status) => FilterOption(label: status.label, value: status)),
      ];

  List<FilterOption<NotificationType>> get typeOptions => [
        const FilterOption<NotificationType>(label: 'All Types'),
        ...NotificationType.values
            .map((type) => FilterOption(label: type.label, value: type)),
      ];
}
