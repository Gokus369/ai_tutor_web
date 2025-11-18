import 'package:flutter/material.dart';

enum ProgressView { modules, students }

enum SubjectStatus { inProgress, completed }

enum StudentAlertType { warning, danger }

class ProgressSummary {
  const ProgressSummary({
    required this.modules,
    required this.students,
  });

  final int modules;
  final int students;
}

class ChapterProgress {
  const ChapterProgress({
    required this.title,
    required this.progress,
    required this.progressLabel,
  });

  final String title;
  final double progress;
  final String progressLabel;
}

class SubjectDetail {
  const SubjectDetail({
    required this.name,
    required this.status,
    required this.focusArea,
    required this.chapters,
    required this.collapsedModules,
  });

  final String name;
  final SubjectStatus status;
  final String focusArea;
  final List<ChapterProgress> chapters;
  final List<String> collapsedModules;
}

class SubjectSummary {
  const SubjectSummary({
    required this.name,
    required this.status,
  });

  final String name;
  final SubjectStatus status;
}

class StudentAlert {
  const StudentAlert({
    required this.label,
    required this.type,
  });

  final String label;
  final StudentAlertType type;

  Color color({required Color warningColor, required Color dangerColor}) {
    switch (type) {
      case StudentAlertType.warning:
        return warningColor;
      case StudentAlertType.danger:
        return dangerColor;
    }
  }
}

class StudentProgress {
  const StudentProgress({
    required this.name,
    required this.progress,
    this.alert,
  });

  final String name;
  final double progress;
  final StudentAlert? alert;
}

class ProgressPageData {
  ProgressPageData({
    required this.classOptions,
    required this.initialClass,
    required this.classes,
  }) : assert(classes.isNotEmpty, 'classes must not be empty');

  final List<String> classOptions;
  final String initialClass;
  final Map<String, ClassProgressData> classes;

  ClassProgressData resolveClass(String className) {
    if (classes.containsKey(className)) {
      return classes[className]!;
    }
    if (classes.containsKey(initialClass)) {
      return classes[initialClass]!;
    }
    return classes.values.first;
  }

  ClassProgressData get initialClassData => resolveClass(initialClass);
}

class ClassProgressData {
  const ClassProgressData({
    required this.summary,
    required this.mathematics,
    required this.additionalSubjects,
    required this.students,
  });

  final ProgressSummary summary;
  final SubjectDetail mathematics;
  final List<SubjectSummary> additionalSubjects;
  final List<StudentProgress> students;
}
