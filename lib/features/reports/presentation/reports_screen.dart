import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<String> _classes = const ['Class 12', 'Class 11', 'Class 10', 'Class 9'];
  String _selectedClass = 'Class 10';

  final List<_SubjectProgressData> _subjects = const [
    _SubjectProgressData('Mathematics', 0.85),
    _SubjectProgressData('Physics', 0.72),
    _SubjectProgressData('Chemistry', 0.64),
    _SubjectProgressData('Biology', 0.83),
    _SubjectProgressData('Social Studies', 0.92),
    _SubjectProgressData('English', 0.56),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.reports,
      builder: (context, shell) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text('Reports', style: AppTypography.dashboardTitle),
                ),
                _ClassSelector(
                  classes: _classes,
                  value: _selectedClass,
                  onChanged: (value) => setState(() => _selectedClass = value),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 147,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      textStyle: AppTypography.button.copyWith(fontSize: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Export Report'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _MetricCardsRow(),
            const SizedBox(height: 28),
            _SubjectProgressPanel(subjects: _subjects),
          ],
        );
      },
    );
  }
}

class _ClassSelector extends StatelessWidget {
  const _ClassSelector({
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
      width: 152,
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
            isDense: true,
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

class _MetricCardsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricCardData(
        title: 'Syllabus Completion',
        value: '65%',
        icon: Icons.menu_book_outlined,
        iconBackground: AppColors.accentPurple.withValues(alpha: 0.12),
        iconColor: AppColors.accentPurple,
      ),
      _MetricCardData(
        title: 'Pass Rate',
        value: '75%',
        icon: Icons.trending_up_rounded,
        iconBackground: AppColors.accentGreen.withValues(alpha: 0.16),
        iconColor: AppColors.accentGreen,
      ),
      _MetricCardData(
        title: 'Needs Attention',
        value: '5',
        icon: Icons.warning_amber_rounded,
        iconBackground: AppColors.accentOrange.withValues(alpha: 0.16),
        iconColor: AppColors.accentOrange,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool wrap = constraints.maxWidth < 1020;
        final children = metrics
            .map(
              (metric) => SizedBox(
                width: wrap ? constraints.maxWidth : 360,
                child: _MetricCard(data: metric),
              ),
            )
            .toList();

        if (wrap) {
          return Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                children[i],
              ],
            ],
          );
        }

        return Row(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 20),
              children[i],
            ],
          ],
        );
      },
    );
  }
}

class _MetricCardData {
  const _MetricCardData({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.data});

  final _MetricCardData data;

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
                  data.title,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 15,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.value,
                  style: AppTypography.dashboardTitle.copyWith(fontSize: 28),
                ),
              ],
            ),
          ),
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: data.iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: Icon(data.icon, color: data.iconColor, size: 28),
          ),
        ],
      ),
    );
  }
}

class _SubjectProgressPanel extends StatelessWidget {
  const _SubjectProgressPanel({required this.subjects});

  final List<_SubjectProgressData> subjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 36),
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
          Text(
            'Subject Progress',
            style: AppTypography.sectionTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              for (int index = 0; index < subjects.length; index++) ...[
                if (index > 0) const SizedBox(height: 20),
                _SubjectProgressTile(data: subjects[index]),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SubjectProgressData {
  const _SubjectProgressData(this.subject, this.progress);

  final String subject;
  final double progress;
}

class _SubjectProgressTile extends StatelessWidget {
  const _SubjectProgressTile({required this.data});

  final _SubjectProgressData data;

  @override
  Widget build(BuildContext context) {
    final double percentage = (data.progress * 100).clamp(0, 100).roundToDouble();

    return Container(
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
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
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
