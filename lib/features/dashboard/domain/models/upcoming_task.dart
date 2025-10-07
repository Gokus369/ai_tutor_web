/// Status for an upcoming dashboard task item.
enum TaskStatus {
  completed,
  pending,
}

/// Data model representing a scheduled task shown in the upcoming tasks table.
class UpcomingTask {
  const UpcomingTask({
    required this.task,
    required this.className,
    required this.date,
    required this.status,
  });

  final String task;
  final String className;
  final DateTime date;
  final TaskStatus status;
}
