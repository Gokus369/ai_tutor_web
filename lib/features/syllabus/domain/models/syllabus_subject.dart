enum SyllabusStatus {
  inProgress,
  completed,
}

class SyllabusModule {
  const SyllabusModule({
    required this.title,
    required this.completionPercentage,
    required this.topicSummary,
  });

  final String title;
  final double completionPercentage;
  final String topicSummary;
}

class SyllabusSubject {
  const SyllabusSubject({
    required this.title,
    required this.status,
    required this.modules,
    required this.additionalTopics,
  });

  final String title;
  final SyllabusStatus status;
  final List<SyllabusModule> modules;
  final List<String> additionalTopics;
}
