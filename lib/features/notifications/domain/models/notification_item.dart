/// Model definitions for the notifications feature.
class NotificationItem {
  const NotificationItem({
    required this.title,
    required this.type,
    required this.recipient,
    required this.scheduledFor,
    required this.status,
  });

  final String title;
  final NotificationType type;
  final String recipient;
  final DateTime scheduledFor;
  final NotificationStatus status;

  NotificationItem copyWith({
    String? title,
    NotificationType? type,
    String? recipient,
    DateTime? scheduledFor,
    NotificationStatus? status,
  }) {
    return NotificationItem(
      title: title ?? this.title,
      type: type ?? this.type,
      recipient: recipient ?? this.recipient,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      status: status ?? this.status,
    );
  }

  static int compareByDateDescending(NotificationItem a, NotificationItem b) {
    return b.scheduledFor.compareTo(a.scheduledFor);
  }
}

enum NotificationType {
  assignment,
  announcement,
  alert,
  reminder,
}

extension NotificationTypeX on NotificationType {
  String get label {
    switch (this) {
      case NotificationType.assignment:
        return 'Assignment';
      case NotificationType.announcement:
        return 'Announcement';
      case NotificationType.alert:
        return 'Alert';
      case NotificationType.reminder:
        return 'Reminder';
    }
  }
}

enum NotificationStatus {
  completed,
  scheduled,
  draft,
}

extension NotificationStatusX on NotificationStatus {
  String get label {
    switch (this) {
      case NotificationStatus.completed:
        return 'Completed';
      case NotificationStatus.scheduled:
        return 'Scheduled';
      case NotificationStatus.draft:
        return 'Draft';
    }
  }
}
