import 'package:flutter/material.dart';

enum AssessmentView { assignments, quizzes, exams }

enum AssessmentStatus { completed, pending, scheduled }

class AssessmentFilterOptions {
  const AssessmentFilterOptions({
    required this.classOptions,
    required this.statusOptions,
    required this.subjectOptions,
    required this.initialClass,
    required this.initialStatus,
    required this.initialSubject,
  });

  final List<String> classOptions;
  final List<String> statusOptions;
  final List<String> subjectOptions;
  final String initialClass;
  final String initialStatus;
  final String initialSubject;
}

class AssessmentRecord {
  const AssessmentRecord({
    required this.title,
    required this.subject,
    required this.dueDateLabel,
    required this.status,
    this.submittedBy,
    this.scoreLabel,
    this.className = 'Class 10',
  });

  final String title;
  final String subject;
  final String dueDateLabel;
  final AssessmentStatus status;
  final String? submittedBy;
  final String? scoreLabel;
  final String className;
}

class AssessmentSectionData {
  const AssessmentSectionData({
    required this.view,
    required this.records,
    required this.columns,
  });

  final AssessmentView view;
  final List<AssessmentRecord> records;
  final List<String> columns;
}

class AssessmentsPageData {
  const AssessmentsPageData({
    required this.filters,
    required this.sections,
  });

  final AssessmentFilterOptions filters;
  final Map<AssessmentView, AssessmentSectionData> sections;
}

extension AssessmentStatusStyling on AssessmentStatus {
  String get label {
    switch (this) {
      case AssessmentStatus.completed:
        return 'Completed';
      case AssessmentStatus.pending:
        return 'Pending';
      case AssessmentStatus.scheduled:
        return 'Scheduled';
    }
  }

  Color chipColor({required Color completed, required Color pending, required Color scheduled}) {
    switch (this) {
      case AssessmentStatus.completed:
        return completed;
      case AssessmentStatus.pending:
        return pending;
      case AssessmentStatus.scheduled:
        return scheduled;
    }
  }
}
