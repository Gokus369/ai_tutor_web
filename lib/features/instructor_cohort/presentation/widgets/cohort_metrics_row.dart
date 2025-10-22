import 'package:ai_tutor_web/features/instructor_cohort/domain/models/cohort_metric.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class CohortMetricsRow extends StatelessWidget {
  const CohortMetricsRow({
    super.key,
    required this.metrics,
    required this.isCompact,
  });

  final List<CohortMetric> metrics;
  final bool isCompact;

  static const double _cardWidth = 262;
  static const double _cardHeight = 110;
  static const double _spacing = 16;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double targetWidth = isCompact ? maxWidth : _cardWidth;
        final int cardsPerRow = isCompact
            ? (maxWidth / (_cardWidth + _spacing)).floor().clamp(
                1,
                metrics.length,
              )
            : metrics.length;

        return Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: isCompact
                    ? (maxWidth / cardsPerRow) - _spacing
                    : _cardWidth,
                height: _cardHeight,
                child: _MetricCard(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final CohortMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: metric.iconBackground.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(metric.icon, color: metric.iconBackground, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.label,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.value,
                  style: AppTypography.sectionTitle.copyWith(fontSize: 26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
