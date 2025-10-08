enum StudentPerformance {
  topPerformer,
  average,
  needAttention,
}

enum StudentStatus {
  active,
  inactive,
}

class StudentReport {
  const StudentReport({
    required this.name,
    required this.className,
    required this.attendance,
    required this.progress,
    required this.performance,
    required this.status,
  });

  final String name;
  final String className;
  final double attendance;
  final double progress;
  final StudentPerformance performance;
  final StudentStatus status;
}
