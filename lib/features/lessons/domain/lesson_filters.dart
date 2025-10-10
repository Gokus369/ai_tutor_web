import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';

class LessonFilterOptions {
  const LessonFilterOptions({
    required this.selectedClass,
    required this.selectedSubject,
    required this.query,
    this.allClassLabel = 'All Classes',
    this.allSubjectLabel = 'All Subjects',
  });

  final String selectedClass;
  final String selectedSubject;
  final String query;
  final String allClassLabel;
  final String allSubjectLabel;
}

List<LessonPlan> filterLessons(
  List<LessonPlan> plans, {
  required LessonFilterOptions options,
}) {
  final String needle = options.query.trim().toLowerCase();
  return plans.where((plan) {
    final bool classMatches = options.selectedClass == options.allClassLabel ||
        plan.className == options.selectedClass;
    final bool subjectMatches = options.selectedSubject == options.allSubjectLabel ||
        plan.subject == options.selectedSubject;
    final bool queryMatches = needle.isEmpty ||
        [
          plan.subject,
          plan.topic,
          plan.description,
          plan.className,
        ].any((value) => value.toLowerCase().contains(needle));

    return classMatches && subjectMatches && queryMatches;
  }).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
}

