import 'package:ai_tutor_web/features/lessons/domain/lesson_filters.dart';
import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final samplePlans = [
    LessonPlan(
      date: DateTime(2025, 8, 31),
      className: 'Class 12',
      subject: 'Mathematics',
      description: 'Linear equations intro',
      topic: 'Introduction',
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 0),
      status: LessonStatus.pending,
    ),
    LessonPlan(
      date: DateTime(2025, 8, 30),
      className: 'Class 10',
      subject: 'Science',
      description: 'Matter and states',
      topic: 'States of Matter',
      startTime: const TimeOfDay(hour: 11, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      status: LessonStatus.completed,
    ),
  ];

  LessonFilterOptions buildOptions({
    String selectedClass = 'All Classes',
    String selectedSubject = 'All Subjects',
    String query = '',
    LessonStatus? status,
  }) {
    return LessonFilterOptions(
      selectedClass: selectedClass,
      selectedSubject: selectedSubject,
      query: query,
      selectedStatus: status,
    );
  }

  test('filter by subject', () {
    final results = filterLessons(
      samplePlans,
      options: buildOptions(selectedSubject: 'Mathematics'),
    );

    expect(results.length, 1);
    expect(results.first.subject, 'Mathematics');
  });

  test('filter by class', () {
    final results = filterLessons(
      samplePlans,
      options: buildOptions(selectedClass: 'Class 10'),
    );
    expect(results.single.className, 'Class 10');
  });

  test('filter by query matches description', () {
    final results = filterLessons(
      samplePlans,
      options: buildOptions(query: 'matter'),
    );
    expect(results.single.subject, 'Science');
  });

  test('filter by status', () {
    final results = filterLessons(
      samplePlans,
      options: buildOptions(status: LessonStatus.completed),
    );
    expect(results.single.status, LessonStatus.completed);
  });
}
