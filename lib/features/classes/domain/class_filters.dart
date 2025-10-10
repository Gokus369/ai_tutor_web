import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';

class ClassFilterOptions {
  const ClassFilterOptions({
    required this.searchTerm,
    required this.selectedBoard,
    this.allBoardsLabel = 'All Boards',
  });

  final String searchTerm;
  final String selectedBoard;
  final String allBoardsLabel;
}

List<ClassInfo> filterClasses(
  List<ClassInfo> classes, {
  required ClassFilterOptions options,
}) {
  final String needle = options.searchTerm.trim().toLowerCase();
  final bool filterByBoard = options.selectedBoard != options.allBoardsLabel;

  return classes.where((info) {
    final bool boardMatches =
        !filterByBoard || info.board.toLowerCase() == options.selectedBoard.toLowerCase();

    final bool textMatches = needle.isEmpty ||
        info.name.toLowerCase().contains(needle) ||
        info.subjectSummary.toLowerCase().contains(needle);

    return boardMatches && textMatches;
  }).toList()
    ..sort((a, b) => a.name.compareTo(b.name));
}

