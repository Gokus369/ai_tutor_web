import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ClassFiltersBar extends StatelessWidget {
  const ClassFiltersBar({
    super.key,
    required this.isCompact,
    required this.boardOptions,
    required this.selectedBoard,
    required this.searchController,
    required this.onBoardChanged,
  });

  final bool isCompact;
  final List<String> boardOptions;
  final String selectedBoard;
  final TextEditingController searchController;
  final ValueChanged<String> onBoardChanged;

  @override
  Widget build(BuildContext context) {
    final dropdown = _BoardDropdown(
      boardOptions: boardOptions,
      selected: selectedBoard,
      onChanged: onBoardChanged,
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          _SearchField(controller: searchController),
          const SizedBox(height: 16),
          dropdown,
        ],
      );
    }

    return Row(
      children: [
        Expanded(flex: 3, child: _SearchField(controller: searchController)),
        const SizedBox(width: 16),
        Expanded(flex: 1, child: dropdown),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search classes or subjects...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: AppColors.syllabusSearchBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _BoardDropdown extends StatelessWidget {
  const _BoardDropdown({
    required this.boardOptions,
    required this.selected,
    required this.onChanged,
  });

  final List<String> boardOptions;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Board',
          style: AppTypography.classCardMeta.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.studentsFilterBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.studentsFilterBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButton<String>(
                value: selected,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                style: AppTypography.classCardMeta,
                onChanged: (value) {
                  if (value == null) return;
                  onChanged(value);
                },
                items: [
                  for (final option in boardOptions)
                    DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

