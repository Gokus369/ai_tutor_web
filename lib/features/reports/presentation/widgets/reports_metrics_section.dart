import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ReportsMetricsSection extends StatelessWidget {
  const ReportsMetricsSection({super.key, required this.metrics});

  final List<ReportMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool wrap = maxWidth < 1080;
        final List<Widget> cards = List.generate(metrics.length, (index) {
          final metric = metrics[index];
          return SizedBox(
            width: wrap ? double.infinity : 340,
            child: ReportsMetricCard(key: ValueKey('reports-metric-$index'), metric: metric),
          );
        });

        if (wrap) {
          return Column(
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                cards[i],
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 20),
              cards[i],
            ],
          ],
        );
      },
    );
  }
}

class ReportsMetricCard extends StatelessWidget {
  const ReportsMetricCard({super.key, required this.metric});

  final ReportMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.sidebarBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.title,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  metric.value,
                  style: AppTypography.dashboardTitle.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: metric.iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(metric.icon, color: metric.iconColor, size: 28),
          ),
        ],
      ),
    );
  }
}
