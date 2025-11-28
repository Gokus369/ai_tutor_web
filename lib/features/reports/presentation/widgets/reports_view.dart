import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/features/reports/presentation/widgets/reports_header.dart';
import 'package:ai_tutor_web/features/reports/presentation/widgets/reports_metrics_section.dart';
import 'package:ai_tutor_web/features/reports/presentation/widgets/reports_subjects_panel.dart';
import 'package:flutter/material.dart';

@visibleForTesting
class ReportsView extends StatelessWidget {
  const ReportsView({
    super.key,
    required this.data,
    required this.selectedClass,
    required this.onClassChanged,
    required this.onExportPressed,
    this.showHeader = true,
  });

  final ReportsData data;
  final String selectedClass;
  final ValueChanged<String> onClassChanged;
  final VoidCallback onExportPressed;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double contentWidth = constraints.maxWidth >= 1200 ? 1200 : constraints.maxWidth;
        final bool compact = contentWidth < 960;
        final EdgeInsets panelPadding = compact
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 24)
            : const EdgeInsets.symmetric(horizontal: 30, vertical: 30);

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: contentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader) ...[
                  ReportsHeader(
                    data: data,
                    selectedClass: selectedClass,
                    onClassChanged: onClassChanged,
                    onExportPressed: onExportPressed,
                    narrow: contentWidth < 720,
                  ),
                  const SizedBox(height: 28),
                ],
                ReportsMetricsSection(metrics: data.metrics),
                const SizedBox(height: 28),
                ReportsSubjectsPanel(subjects: data.subjects, padding: panelPadding),
              ],
            ),
          ),
        );
      },
    );
  }
}
