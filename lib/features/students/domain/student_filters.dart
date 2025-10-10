import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';

class StudentFilterOptions {
  const StudentFilterOptions({
    required this.searchTerm,
    required this.classOption,
    required this.attendanceOption,
    required this.progressOption,
    required this.performanceOption,
    this.allClassesLabel = 'All Classes',
    this.allAttendanceLabel = 'All Attendance',
    this.allProgressLabel = 'All Progress',
    this.allPerformanceLabel = 'All Levels',
  });

  final String searchTerm;
  final String classOption;
  final String attendanceOption;
  final String progressOption;
  final String performanceOption;

  final String allClassesLabel;
  final String allAttendanceLabel;
  final String allProgressLabel;
  final String allPerformanceLabel;
}

List<StudentReport> filterStudents(
  List<StudentReport> students, {
  required StudentFilterOptions options,
}) {
  final String needle = options.searchTerm.trim().toLowerCase();

  return students.where((student) {
    final bool matchesClass = options.classOption == options.allClassesLabel ||
        student.className.toLowerCase() == options.classOption.toLowerCase();

    final bool matchesAttendance = _matchesRange(
      value: student.attendance,
      option: options.attendanceOption,
      allLabel: options.allAttendanceLabel,
      ranges: {
        'Above 90%': const _Range(min: 0.9),
        '70% - 90%': const _Range(min: 0.7, max: 0.9),
        'Below 70%': const _Range(max: 0.7),
      },
    );

    final bool matchesProgress = _matchesRange(
      value: student.progress,
      option: options.progressOption,
      allLabel: options.allProgressLabel,
      ranges: {
        'Above 80%': const _Range(min: 0.8),
        '50% - 80%': const _Range(min: 0.5, max: 0.8),
        'Below 50%': const _Range(max: 0.5),
      },
    );

    final bool matchesPerformance = options.performanceOption == options.allPerformanceLabel ||
        _performanceLabel(student.performance) == options.performanceOption;

    final bool matchesSearch = needle.isEmpty ||
        [
          student.name,
          student.className,
          _performanceLabel(student.performance),
        ].any((value) => value.toLowerCase().contains(needle));

    return matchesClass && matchesAttendance && matchesProgress && matchesPerformance && matchesSearch;
  }).toList()
    ..sort((a, b) => a.name.compareTo(b.name));
}

bool _matchesRange({
  required double value,
  required String option,
  required String allLabel,
  required Map<String, _Range> ranges,
}) {
  if (option == allLabel) return true;
  final range = ranges[option];
  if (range == null) return true;
  final bool lowerOk = range.min == null || value >= range.min!;
  final bool upperOk = range.max == null || value < range.max!;
  return lowerOk && upperOk;
}

String _performanceLabel(StudentPerformance performance) {
  switch (performance) {
    case StudentPerformance.topPerformer:
      return 'Top Performer';
    case StudentPerformance.average:
      return 'Average';
    case StudentPerformance.needAttention:
      return 'Need Attention';
  }
}

class _Range {
  const _Range({this.min, this.max});

  final double? min;
  final double? max;
}

