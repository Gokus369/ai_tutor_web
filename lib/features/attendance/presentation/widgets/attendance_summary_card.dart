import 'package:ai_tutor_web/features/lessons/presentation/utils/lesson_formatters.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({
    super.key,
    required this.date,
    required this.totalStudents,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });

  final DateTime date;
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final int lateCount;

  @override
  Widget build(BuildContext context) {
    final String ratioText = totalStudents == 0
        ? '0/0'
        : '$presentCount/$totalStudents';
    final int attendancePercent = totalStudents == 0
        ? 0
        : ((presentCount / totalStudents) * 100).round();
    final String attendanceLabel = totalStudents == 0
        ? 'No attendance recorded'
        : '$attendancePercent% attendance';

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.summaryCardGradientStart,
            AppColors.summaryCardGradientEnd,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.summaryCardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Today's Summary",
            style: AppTypography.sectionTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 18),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  ratioText,
                  style: AppTypography.dashboardTitle.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Students present',
                  style: AppTypography.classCardMeta.copyWith(
                    color: AppColors.greyMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                _SummaryHighlightChip(
                  label: attendanceLabel,
                  background: AppColors.accentGreen.withValues(alpha: 0.18),
                  textColor: AppColors.accentGreen,
                ),
                const SizedBox(height: 12),
                Text(
                  formatLessonDate(date),
                  style: AppTypography.classCardMeta.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            height: 32,
            thickness: 1,
            color: AppColors.studentsTableDivider,
          ),
          const SizedBox(height: 16),
          _SummaryStatusRow(
            icon: Icons.check_circle,
            label: 'Present',
            count: presentCount,
            color: AppColors.accentGreen,
          ),
          const SizedBox(height: 16),
          _SummaryStatusRow(
            icon: Icons.remove_circle,
            label: 'Absent',
            count: absentCount,
            color: AppColors.accentPink,
          ),
          const SizedBox(height: 16),
          _SummaryStatusRow(
            icon: Icons.access_time,
            label: 'Late',
            count: lateCount,
            color: AppColors.accentRed,
          ),
        ],
      ),
    );
  }
}

class _SummaryStatusRow extends StatelessWidget {
  const _SummaryStatusRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTypography.classCardMeta.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _SummaryCountBadge(value: count, color: color),
      ],
    );
  }
}

class _SummaryCountBadge extends StatelessWidget {
  const _SummaryCountBadge({required this.value, required this.color});

  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32, minHeight: 28),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value.toString(),
        style: AppTypography.classCardMeta.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SummaryHighlightChip extends StatelessWidget {
  const _SummaryHighlightChip({
    required this.label,
    required this.background,
    required this.textColor,
  });

  final String label;
  final Color background;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTypography.classCardMeta.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
