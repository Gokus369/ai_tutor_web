import 'package:flutter/material.dart';

const List<String> _monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatLessonDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = _monthNames[date.month - 1];
  final year = date.year.toString();
  return '$day $month $year';
}

String formatLessonTime(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

String formatLessonTimeRange(TimeOfDay start, TimeOfDay end) {
  return '${formatLessonTime(start)} - ${formatLessonTime(end)}';
}

