import 'package:ai_tutor_web/features/classes/domain/class_filters.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final classes = [
    const ClassInfo(
      name: 'Class 12',
      board: 'CBSE',
      studentCount: 45,
      subjectSummary: 'Mathematics, Physics',
      syllabusProgress: 0.7,
    ),
    const ClassInfo(
      name: 'Class 10',
      board: 'ICSE',
      studentCount: 40,
      subjectSummary: 'English, History',
      syllabusProgress: 0.6,
    ),
  ];

  test('filters by board', () {
    final filtered = filterClasses(
      classes,
      options: const ClassFilterOptions(
        searchTerm: '',
        selectedBoard: 'CBSE',
      ),
    );
    expect(filtered.map((c) => c.board), ['CBSE']);
  });

  test('filters by search term', () {
    final filtered = filterClasses(
      classes,
      options: const ClassFilterOptions(
        searchTerm: 'history',
        selectedBoard: 'All Boards',
      ),
    );
    expect(filtered.single.name, 'Class 10');
  });

  test('returns sorted results', () {
    final filtered = filterClasses(
      classes,
      options: const ClassFilterOptions(
        searchTerm: '',
        selectedBoard: 'All Boards',
      ),
    );
    expect(filtered.first.name.compareTo(filtered.last.name) <= 0, isTrue);
  });
}

