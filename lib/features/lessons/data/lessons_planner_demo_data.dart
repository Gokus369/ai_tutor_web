import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';
import 'package:flutter/material.dart';

class LessonsPlannerDemoData {
  static const List<String> classOptions = [
    'All Classes',
    'Class 12',
    'Class 11',
    'Class 10',
  ];

  static const List<String> subjectOptions = [
    'All Subjects',
    'Mathematics',
    'Science',
    'English',
    'History',
  ];

  static final List<LessonPlan> plans = List<LessonPlan>.unmodifiable([
    LessonPlan(
      date: DateTime(2025, 8, 31),
      className: 'Class 12',
      subject: 'Mathematics',
      description: 'Chapter 1: Linear Equations',
      topic: 'Linear Equations Introduction',
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 10, minute: 0),
      status: LessonStatus.pending,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 30),
      className: 'Class 12',
      subject: 'Mathematics',
      description: 'Chapter 1: Linear Equations',
      topic: 'Solving Word Problems',
      startTime: TimeOfDay(hour: 9, minute: 0),
      endTime: TimeOfDay(hour: 10, minute: 0),
      status: LessonStatus.pending,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 28),
      className: 'Class 11',
      subject: 'Science',
      description: 'Chapter 5: Matter in Our Surroundings',
      topic: 'States of Matter',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      status: LessonStatus.pending,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 27),
      className: 'Class 11',
      subject: 'English',
      description: 'Chapter 3: Literature',
      topic: 'Poetry Analysis Workshop',
      startTime: TimeOfDay(hour: 14, minute: 0),
      endTime: TimeOfDay(hour: 15, minute: 0),
      status: LessonStatus.pending,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 26),
      className: 'Class 10',
      subject: 'Mathematics',
      description: 'Chapter 2: Geometry',
      topic: 'Geometry Review',
      startTime: TimeOfDay(hour: 11, minute: 0),
      endTime: TimeOfDay(hour: 12, minute: 0),
      status: LessonStatus.completed,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 25),
      className: 'Class 10',
      subject: 'Mathematics',
      description: 'Chapter 2: Geometry',
      topic: 'Geometry Review',
      startTime: TimeOfDay(hour: 10, minute: 0),
      endTime: TimeOfDay(hour: 11, minute: 0),
      status: LessonStatus.completed,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 24),
      className: 'Class 10',
      subject: 'English',
      description: 'Chapter 3: Literature',
      topic: 'Geometry Review',
      startTime: TimeOfDay(hour: 14, minute: 0),
      endTime: TimeOfDay(hour: 15, minute: 0),
      status: LessonStatus.completed,
    ),
  ]);
}
