part of 'teacher_cubit.dart';

enum TeacherStatus { initial, loading, success, error }

class TeacherState {
  const TeacherState({
    this.status = TeacherStatus.initial,
    this.teachers = const [],
    this.error,
    this.currentPage = 1,
    this.hasNext = false,
  });

  final TeacherStatus status;
  final List<Teacher> teachers;
  final String? error;
  final int currentPage;
  final bool hasNext;

  TeacherState copyWith({
    TeacherStatus? status,
    List<Teacher>? teachers,
    String? error,
    int? currentPage,
    bool? hasNext,
  }) {
    return TeacherState(
      status: status ?? this.status,
      teachers: teachers ?? this.teachers,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherState &&
        other.status == status &&
        other.error == error &&
        other.currentPage == currentPage &&
        other.hasNext == hasNext &&
        _listEquals(other.teachers, teachers);
  }

  @override
  int get hashCode =>
      status.hashCode ^
      error.hashCode ^
      currentPage.hashCode ^
      hasNext.hashCode ^
      teachers.hashCode;

  bool _listEquals(List<Teacher> a, List<Teacher> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      final left = a[i];
      final right = b[i];
      if (left.id != right.id ||
          left.name != right.name ||
          left.email != right.email ||
          left.phone != right.phone ||
          left.subject != right.subject ||
          left.attendance != right.attendance ||
          left.schoolId != right.schoolId ||
          left.schoolName != right.schoolName) {
        return false;
      }
    }
    return true;
  }
}
