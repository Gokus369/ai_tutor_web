import 'package:ai_tutor_web/features/students/domain/models/student_report.dart';
import 'package:ai_tutor_web/features/students/domain/student_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final students = [
    const StudentReport(
      name: 'Alice',
      className: 'Class 12',
      attendance: 0.95,
      progress: 0.88,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const StudentReport(
      name: 'Bob',
      className: 'Class 10',
      attendance: 0.68,
      progress: 0.45,
      performance: StudentPerformance.needAttention,
      status: StudentStatus.inactive,
    ),
  ];

  StudentFilterOptions buildOptions({
    String search = '',
    String classOption = 'All Classes',
    String attendanceOption = 'All Attendance',
    String progressOption = 'All Progress',
    String performanceOption = 'All Levels',
  }) {
    return StudentFilterOptions(
      searchTerm: search,
      classOption: classOption,
      attendanceOption: attendanceOption,
      progressOption: progressOption,
      performanceOption: performanceOption,
    );
  }

  test('filters by class selection', () {
    final results = filterStudents(
      students,
      options: buildOptions(classOption: 'Class 12'),
    );
    expect(results.single.name, 'Alice');
  });

  test('filters by attendance range', () {
    final results = filterStudents(
      students,
      options: buildOptions(attendanceOption: 'Below 70%'),
    );
    expect(results.single.name, 'Bob');
  });

  test('filters by performance level', () {
    final results = filterStudents(
      students,
      options: buildOptions(performanceOption: 'Top Performer'),
    );
    expect(results.single.performance, StudentPerformance.topPerformer);
  });

  test('filters by search term', () {
    final results = filterStudents(
      students,
      options: buildOptions(search: 'bob'),
    );
    expect(results.single.name, 'Bob');
  });
}

