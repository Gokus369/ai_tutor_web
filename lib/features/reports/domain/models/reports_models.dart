import 'package:flutter/material.dart';

class ReportsData {
  const ReportsData({
    required this.classOptions,
    required this.initialClass,
    required this.metrics,
    required this.subjects,
  });

  final List<String> classOptions;
  final String initialClass;
  final List<ReportMetric> metrics;
  final List<SubjectProgress> subjects;
}

class ReportMetric {
  const ReportMetric({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
}

class SubjectProgress {
  const SubjectProgress({
    required this.subject,
    required this.progress,
  });

  final String subject;
  final double progress;
}
