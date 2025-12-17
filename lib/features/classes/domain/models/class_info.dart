class ClassInfo {
  const ClassInfo({
    required this.id,
    required this.name,
    required this.board,
    required this.boardId,
    required this.schoolId,
    this.schoolName,
    this.section,
    this.startDate,
    required this.studentCount,
    required this.subjectSummary,
    required this.syllabusProgress,
  });

  final int id;
  final String name;
  final String board;
  final int boardId;
  final int schoolId;
  final String? schoolName;
  final String? section;
  final DateTime? startDate;
  final int studentCount;
  final String subjectSummary;
  final double syllabusProgress;
}
