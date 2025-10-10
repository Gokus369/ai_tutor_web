import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/upcoming_tasks_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static final List<DashboardSummary> _summaryMetrics = [
    DashboardSummary(
      title: 'Total Students',
      value: '120',
      icon: Icons.people_alt_outlined,
      iconBackground: AppColors.metricIconBlue,
    ),
    DashboardSummary(
      title: 'Active Students',
      value: '85',
      icon: Icons.person_outline,
      iconBackground: AppColors.metricIconGreen,
    ),
    DashboardSummary(
      title: 'Quizzes Assigned',
      value: '12',
      icon: Icons.quiz_outlined,
      iconBackground: AppColors.metricIconYellow,
    ),
    DashboardSummary(
      title: 'Top Performers',
      value: '10',
      icon: Icons.emoji_events_outlined,
      iconBackground: AppColors.metricIconPeach,
    ),
  ];

  static final List<QuickAction> _quickActions = [
    QuickAction(
      label: 'Create Class',
      icon: Icons.add,
      color: AppColors.quickActionBlue,
    ),
    QuickAction(
      label: 'Add Lesson',
      icon: Icons.calendar_today_outlined,
      color: AppColors.quickActionGreen,
    ),
    QuickAction(
      label: 'Assign Quiz',
      icon: Icons.assignment_outlined,
      color: AppColors.quickActionPurple,
    ),
    QuickAction(
      label: 'Send Announcement',
      icon: Icons.campaign_outlined,
      color: AppColors.quickActionOrange,
    ),
  ];

  static final List<UpcomingTask> _upcomingTasks = [
    UpcomingTask(
      task: 'Prepare Maths Lesson',
      className: '8th Std',
      date: DateTime(2025, 9, 12),
      status: TaskStatus.completed,
    ),
    UpcomingTask(
      task: 'Science Quiz',
      className: '10th Std',
      date: DateTime(2025, 9, 15),
      status: TaskStatus.pending,
    ),
    UpcomingTask(
      task: 'English Chapter 5',
      className: '10th Std',
      date: DateTime(2025, 9, 17),
      status: TaskStatus.pending,
    ),
    UpcomingTask(
      task: 'Maths Quiz',
      className: '9th Std',
      date: DateTime(2025, 9, 15),
      status: TaskStatus.pending,
    ),
    UpcomingTask(
      task: 'Chemistry Quiz',
      className: '9th Std',
      date: DateTime(2025, 9, 15),
      status: TaskStatus.pending,
    ),
    UpcomingTask(
      task: 'Maths Chapter 7',
      className: '8th Std',
      date: DateTime(2025, 9, 17),
      status: TaskStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.dashboard,
      builder: (context, shell) {
        final double width = shell.contentWidth;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Dashboard', style: AppTypography.dashboardTitle),
            const SizedBox(height: 24),
            DashboardSummarySection(metrics: _summaryMetrics, availableWidth: width),
            const SizedBox(height: 28),
            DashboardQuickActions(
              actions: _quickActions,
              availableWidth: width,
              isDesktop: shell.isDesktop,
            ),
            SizedBox(height: shell.isDesktop ? 36 : 28),
            UpcomingTasksTable(
              tasks: _upcomingTasks,
              compact: !(shell.isDesktop || shell.isTablet),
            ),
          ],
        );
      },
    );
  }
}
