import 'package:ai_tutor_web/features/lessons/presentation/utils/lesson_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formatLessonDate produces expected string', () {
    final result = formatLessonDate(DateTime(2025, 8, 31));
    expect(result, '31 Aug 2025');
  });

  test('formatLessonTime converts to 12-hour clock', () {
    expect(formatLessonTime(const TimeOfDay(hour: 0, minute: 5)), '12:05 AM');
    expect(formatLessonTime(const TimeOfDay(hour: 12, minute: 0)), '12:00 PM');
    expect(formatLessonTime(const TimeOfDay(hour: 15, minute: 30)), '3:30 PM');
  });

  test('formatLessonTimeRange combines start and end', () {
    final range = formatLessonTimeRange(
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 10, minute: 30),
    );
    expect(range, '9:00 AM - 10:30 AM');
  });
}

