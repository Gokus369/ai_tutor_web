import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({
    super.key,
    required this.summary,
    required this.compact,
    required this.classOptions,
    required this.selectedClass,
    required this.view,
    required this.onClassChanged,
    required this.onViewChanged,
    this.searchController,
    this.onSearchChanged,
  });

  final ProgressSummary summary;
  final bool compact;
  final List<String> classOptions;
  final String selectedClass;
  final ProgressView view;
  final ValueChanged<String?> onClassChanged;
  final ValueChanged<ProgressView> onViewChanged;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  bool get _showSearch => view == ProgressView.students && searchController != null;

  @override
  Widget build(BuildContext context) {
    final double basePadding = compact ? 18 : 24;
    return Container(
      decoration: ProgressStyles.elevatedCard(),
      padding: EdgeInsets.all(basePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Overview',
                      style: AppTypography.sectionTitle.copyWith(fontSize: compact ? 22 : 24),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: [
                        _MetricChip(label: 'Modules', value: '${summary.modules}'),
                        _MetricChip(label: 'Students', value: '${summary.students}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: compact ? 280 : 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(selectedClass),
                        initialValue: selectedClass,
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
                        items: classOptions
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
                        onChanged: onClassChanged,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          textStyle: AppTypography.button,
                        ),
                        icon: const Icon(Icons.file_upload_outlined, size: 20),
                        label: const Text('Export Report'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _ViewToggleChip(
                label: 'Modules',
                active: view == ProgressView.modules,
                onTap: () => onViewChanged(ProgressView.modules),
              ),
              const SizedBox(width: 12),
              _ViewToggleChip(
                label: 'Students',
                active: view == ProgressView.students,
                onTap: () => onViewChanged(ProgressView.students),
              ),
            ],
          ),
          if (_showSearch) ...[
            const SizedBox(height: 20),
            SizedBox(
              height: 64,
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                  hintText: 'Search students',
                  hintStyle: AppTypography.bodySmall.copyWith(
                    color: AppColors.greyMuted,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: AppColors.syllabusSearchBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: AppColors.sidebarBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: AppColors.sidebarBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.progressChipBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.progressChipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.metricValue.copyWith(
              fontSize: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewToggleChip extends StatelessWidget {
  const _ViewToggleChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color background = active ? AppColors.primary : AppColors.white;
    final Color border = active ? AppColors.primary : AppColors.progressChipBorder;
    final Color foreground = active ? AppColors.white : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
