import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/reports/data/reports_demo_data.dart';
import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({super.key, ReportsData? data}) : data = data ?? ReportsDemoData.build();

  final ReportsData data;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ReportsData _data = widget.data;
  late String _selectedClass = widget.data.initialClass;

  @override
  void didUpdateWidget(covariant ReportsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _data = widget.data;
      _selectedClass = _data.initialClass;
    }
  }

  void _onClassChanged(String value) {
    setState(() => _selectedClass = value);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.reports,
      builder: (context, shell) {
        return ReportsView(
          data: _data,
          selectedClass: _selectedClass,
          onClassChanged: _onClassChanged,
          onExportPressed: () {},
        );
      },
    );
  }
}

@visibleForTesting
class ReportsView extends StatelessWidget {
  const ReportsView({
    super.key,
    required this.data,
    required this.selectedClass,
    required this.onClassChanged,
    required this.onExportPressed,
  });

  final ReportsData data;
  final String selectedClass;
  final ValueChanged<String> onClassChanged;
  final VoidCallback onExportPressed;

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
                _ReportsHeader(
                  data: data,
                  selectedClass: selectedClass,
                  onClassChanged: onClassChanged,
                  onExportPressed: onExportPressed,
                ),
                const SizedBox(height: 28),
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

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader({
    required this.data,
    required this.selectedClass,
    required this.onClassChanged,
    required this.onExportPressed,
  });

  final ReportsData data;
  final String selectedClass;
  final ValueChanged<String> onClassChanged;
  final VoidCallback onExportPressed;

  @override
  Widget build(BuildContext context) {
    final bool narrow = MediaQuery.sizeOf(context).width < 720;
    final dropdown = ReportsClassSelector(
      classes: data.classOptions,
      value: selectedClass,
      onChanged: onClassChanged,
    );

    final exportButton = SizedBox(
      width: 147,
      height: 50,
      child: FilledButton(
        onPressed: onExportPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.button.copyWith(fontSize: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: const Text('Export Report'),
      ),
    );

    if (narrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reports', style: AppTypography.dashboardTitle),
          const SizedBox(height: 18),
          dropdown,
          const SizedBox(height: 12),
          exportButton,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text('Reports', style: AppTypography.dashboardTitle)),
        dropdown,
        const SizedBox(width: 16),
        exportButton,
      ],
    );
  }
}

class ReportsClassSelector extends StatelessWidget {
  const ReportsClassSelector({
    super.key,
    required this.classes,
    required this.value,
    required this.onChanged,
  });

  final List<String> classes;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 172,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.sidebarBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.sidebarBorder),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.iconMuted),
            isExpanded: true,
            onChanged: (selected) {
              if (selected == null) return;
              onChanged(selected);
            },
            items: classes
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

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
      height: 113,
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

class ReportsSubjectsPanel extends StatelessWidget {
  const ReportsSubjectsPanel({super.key, required this.subjects, required this.padding});

  final List<SubjectProgress> subjects;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE4F0F5), Color(0xFFF5FBFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.sidebarBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Subject Progress', style: AppTypography.sectionTitle.copyWith(fontSize: 20)),
          const SizedBox(height: 24),
          Column(
            children: [
              for (int i = 0; i < subjects.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                SubjectProgressTile(data: subjects[i]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class SubjectProgressTile extends StatelessWidget {
  const SubjectProgressTile({super.key, required this.data});

  final SubjectProgress data;

  @override
  Widget build(BuildContext context) {
    final double percentage = (data.progress.clamp(0, 1) * 100).roundToDouble();

    return Container(
      key: ValueKey('reports-subject-${data.subject}'),
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.sidebarBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              data.subject,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: LinearProgressIndicator(
                      value: data.progress.clamp(0, 1),
                      minHeight: 10,
                      backgroundColor: AppColors.searchFieldBorder.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                SizedBox(
                  width: 44,
                  child: Text(
                    '${percentage.toInt()}%',
                    textAlign: TextAlign.right,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
