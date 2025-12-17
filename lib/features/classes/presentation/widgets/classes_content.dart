import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_filters_bar.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_grid.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/classes_empty_state.dart';
import 'package:flutter/material.dart';

class ClassesContent extends StatelessWidget {
  const ClassesContent({
    super.key,
    required this.isCompact,
    required this.classes,
    required this.boardOptions,
    required this.selectedBoard,
    required this.onBoardChanged,
    required this.searchController,
    required this.contentWidth,
    this.onPatch,
    this.onDelete,
  });

  final bool isCompact;
  final List<ClassInfo> classes;
  final List<String> boardOptions;
  final String selectedBoard;
  final ValueChanged<String> onBoardChanged;
  final TextEditingController searchController;
  final double contentWidth;
  final ValueChanged<ClassInfo>? onPatch;
  final ValueChanged<ClassInfo>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClassFiltersBar(
          isCompact: isCompact,
          boardOptions: boardOptions,
          selectedBoard: selectedBoard,
          searchController: searchController,
          onBoardChanged: onBoardChanged,
        ),
        const SizedBox(height: 24),
        if (classes.isEmpty)
          const ClassesEmptyState()
        else
          ClassGrid(
            classes: classes,
            contentWidth: contentWidth,
            onPatch: onPatch,
            onDelete: onDelete,
          ),
      ],
    );
  }
}
