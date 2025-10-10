import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/utils/dashboard_layout.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_card.dart';
import 'package:flutter/material.dart';

class DashboardSummarySection extends StatelessWidget {
  const DashboardSummarySection({
    super.key,
    required this.metrics,
    required this.availableWidth,
  });

  final List<DashboardSummary> metrics;
  final double availableWidth;

  @override
  Widget build(BuildContext context) {
    final layout = buildSummaryLayout(availableWidth);
    return Wrap(
      spacing: layout.spacing,
      runSpacing: layout.spacing,
      children: [
        for (final metric in metrics)
          SizedBox(
            width: layout.columns == 1 ? double.infinity : layout.itemWidth,
            child: DashboardSummaryCard(
              title: metric.title,
              value: metric.value,
              icon: metric.icon,
              iconBackground: metric.iconBackground,
            ),
          ),
      ],
    );
  }
}

