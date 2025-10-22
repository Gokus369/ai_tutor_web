class LearnerProgress {
  const LearnerProgress({
    required this.name,
    required this.completionPercent,
  }) : assert(
          completionPercent >= 0 && completionPercent <= 100,
          'completionPercent must be between 0 and 100',
        );

  final String name;
  final double completionPercent;
}
