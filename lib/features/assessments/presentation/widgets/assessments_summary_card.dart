import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

/// Responsive card that presents the assessment filters, quick actions, and view tabs.
class AssessmentsSummaryCard extends StatelessWidget {
  const AssessmentsSummaryCard({
    super.key,
    required this.filters,
    required this.activeView,
    required this.onViewChanged,
    required this.onClassChanged,
    required this.onStatusChanged,
    required this.onSubjectChanged,
    required this.searchController,
    required this.onSearchChanged,
    this.onCreatePressed,
  });

  final AssessmentFilterOptions filters;
  final AssessmentView activeView;
  final ValueChanged<AssessmentView> onViewChanged;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onSubjectChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final _SummaryLayoutConfig layout = _SummaryLayoutConfig.fromWidth(constraints.maxWidth);
        return Container(
          key: const ValueKey('assessments-summary-card'),
          decoration: AssessmentsStyles.cardDecoration(),
          padding: layout.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryHeader(
                key: const ValueKey('assessments-summary-header'),
                filters: filters,
                collapseHeader: layout.collapseHeader,
                onClassChanged: onClassChanged,
                onCreatePressed: onCreatePressed ?? () {},
              ),
              const SizedBox(height: 18),
              _SummaryFilters(
                key: const ValueKey('assessments-summary-filters'),
                filters: filters,
                stackFilters: layout.stackFilters,
                searchController: searchController,
                onSearchChanged: onSearchChanged,
                onStatusChanged: onStatusChanged,
                onSubjectChanged: onSubjectChanged,
              ),
              const SizedBox(height: 18),
              _SummaryViewTabs(
                key: const ValueKey('assessments-summary-view-chips'),
                activeView: activeView,
                onViewChanged: onViewChanged,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Dropdown extends StatelessWidget {
  const _Dropdown({super.key, required this.initialValue, required this.options, required this.onChanged});

  final String initialValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: ValueKey(initialValue),
      initialValue: initialValue,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: AppColors.syllabusSearchBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.sidebarBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.sidebarBorder),
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 24),
      items: options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _SummaryLayoutConfig {
  const _SummaryLayoutConfig({
    required this.collapseHeader,
    required this.stackFilters,
    required this.padding,
  });

  factory _SummaryLayoutConfig.fromWidth(double width) {
    final bool collapseHeader = width < 720;
    final bool stackFilters = width < 860;
    return _SummaryLayoutConfig(
      collapseHeader: collapseHeader,
      stackFilters: stackFilters,
      padding: AssessmentsStyles.sectionPadding(collapseHeader),
    );
  }

  final bool collapseHeader;
  final bool stackFilters;
  final EdgeInsets padding;
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({
    super.key,
    required this.filters,
    required this.collapseHeader,
    required this.onClassChanged,
    required this.onCreatePressed,
  });

  final AssessmentFilterOptions filters;
  final bool collapseHeader;
  final ValueChanged<String?> onClassChanged;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final dropdown = SizedBox(
      width: collapseHeader ? double.infinity : 151,
      child: _Dropdown(
        key: ValueKey('assessments-class-${filters.initialClass}'),
        initialValue: filters.initialClass,
        options: filters.classOptions,
        onChanged: onClassChanged,
      ),
    );

    final button = SizedBox(
      key: const ValueKey('assessments-create-assessment-button'),
      width: collapseHeader ? double.infinity : null,
      height: 50,
      child: FilledButton.icon(
        onPressed: onCreatePressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Create Assessment'),
      ),
    );

    final Widget layout = collapseHeader
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Assessments', style: AppTypography.sectionTitle.copyWith(fontSize: 24)),
              const SizedBox(height: 14),
              dropdown,
              const SizedBox(height: 12),
              button,
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Text('Assessments', style: AppTypography.sectionTitle.copyWith(fontSize: 24)),
              ),
              dropdown,
              const SizedBox(width: 16),
              button,
            ],
          );

    final Key layoutKey = collapseHeader
        ? const ValueKey('assessments-summary-header-collapsed-layout')
        : const ValueKey('assessments-summary-header-expanded-layout');

    return KeyedSubtree(
      key: layoutKey,
      child: layout,
    );
  }
}

class _SummaryFilters extends StatelessWidget {
  const _SummaryFilters({
    super.key,
    required this.filters,
    required this.stackFilters,
    required this.searchController,
    required this.onSearchChanged,
    required this.onStatusChanged,
    required this.onSubjectChanged,
  });

  final AssessmentFilterOptions filters;
  final bool stackFilters;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onSubjectChanged;

  @override
  Widget build(BuildContext context) {
    final searchField = SizedBox(
      height: 48,
      child: TextField(
        key: const ValueKey('assessments-search'),
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          hintText: 'Search assessments, quizzes and exams…',
          hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.greyMuted),
          filled: true,
          fillColor: AppColors.syllabusSearchBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.sidebarBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.sidebarBorder),
          ),
        ),
      ),
    );

    final statusDropdown = SizedBox(
      width: stackFilters ? double.infinity : 151,
      child: _Dropdown(
        key: ValueKey('assessments-status-${filters.initialStatus}'),
        initialValue: filters.initialStatus,
        options: filters.statusOptions,
        onChanged: onStatusChanged,
      ),
    );

    final subjectDropdown = SizedBox(
      width: stackFilters ? double.infinity : 151,
      child: _Dropdown(
        key: ValueKey('assessments-subject-${filters.initialSubject}'),
        initialValue: filters.initialSubject,
        options: filters.subjectOptions,
        onChanged: onSubjectChanged,
      ),
    );

    final Widget layout = stackFilters
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchField,
              const SizedBox(height: 12),
              statusDropdown,
              const SizedBox(height: 12),
              subjectDropdown,
            ],
          )
        : Row(
            children: [
              Expanded(child: searchField),
              const SizedBox(width: 16),
              statusDropdown,
              const SizedBox(width: 16),
              subjectDropdown,
            ],
          );

    final Key layoutKey = stackFilters
        ? const ValueKey('assessments-summary-filters-stacked-layout')
        : const ValueKey('assessments-summary-filters-inline-layout');

    return KeyedSubtree(
      key: layoutKey,
      child: layout,
    );
  }
}

class _SummaryViewTabs extends StatelessWidget {
  const _SummaryViewTabs({
    super.key,
    required this.activeView,
    required this.onViewChanged,
  });

  final AssessmentView activeView;
  final ValueChanged<AssessmentView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _SummaryTab(
        tabKey: const ValueKey('assessments-view-assignments'),
        label: 'Assignments',
        active: activeView == AssessmentView.assignments,
        onTap: () => onViewChanged(AssessmentView.assignments),
      ),
      _SummaryTab(
        tabKey: const ValueKey('assessments-view-quizzes'),
        label: 'Quizzes',
        active: activeView == AssessmentView.quizzes,
        onTap: () => onViewChanged(AssessmentView.quizzes),
      ),
      _SummaryTab(
        tabKey: const ValueKey('assessments-view-exams'),
        label: 'Exams',
        active: activeView == AssessmentView.exams,
        onTap: () => onViewChanged(AssessmentView.exams),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wrap = constraints.maxWidth < 360;
        if (wrap) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < tabs.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                tabs[i],
              ],
            ],
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < tabs.length; i++) ...[
              if (i > 0) const SizedBox(width: 32),
              tabs[i],
            ],
          ],
        );
      },
    );
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({
    required this.label,
    required this.active,
    required this.onTap,
    required this.tabKey,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Key tabKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tabKey,
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.primary : AppColors.grey,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: active ? 60 : 0,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
