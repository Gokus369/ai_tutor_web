part of 'school_cubit.dart';

enum SchoolStatus { initial, loading, success, error }

class SchoolState {
  const SchoolState({
    this.status = SchoolStatus.initial,
    this.schools = const [],
    this.error,
    this.currentPage = 1,
    this.hasNext = false,
  });

  final SchoolStatus status;
  final List<School> schools;
  final String? error;
  final int currentPage;
  final bool hasNext;

  SchoolState copyWith({
    SchoolStatus? status,
    List<School>? schools,
    String? error,
    int? currentPage,
    bool? hasNext,
  }) {
    return SchoolState(
      status: status ?? this.status,
      schools: schools ?? this.schools,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasNext: hasNext ?? this.hasNext,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SchoolState &&
        other.status == status &&
        other.error == error &&
        other.currentPage == currentPage &&
        other.hasNext == hasNext &&
        _listEquals(other.schools, schools);
  }

  @override
  int get hashCode =>
      status.hashCode ^
      error.hashCode ^
      currentPage.hashCode ^
      hasNext.hashCode ^
      schools.hashCode;

  bool _listEquals(List<School> a, List<School> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      final left = a[i];
      final right = b[i];
      if (left.name != right.name ||
          left.address != right.address ||
          left.code != right.code ||
          left.boardId != right.boardId ||
          left.createdById != right.createdById ||
          left.principalId != right.principalId ||
          left.id != right.id) {
        return false;
      }
    }
    return true;
  }
}
