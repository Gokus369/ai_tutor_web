import 'package:flutter/material.dart';

enum LessonStatus { pending, completed }

class LessonPlan {
  const LessonPlan({
    required this.date,
    required this.className,
    required this.subject,
    required this.topic,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  final DateTime date;
  final String className;
  final String subject;
  final String topic;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final LessonStatus status;
}
