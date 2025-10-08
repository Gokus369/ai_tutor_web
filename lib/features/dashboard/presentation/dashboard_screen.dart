import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_card.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_top_bar.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/upcoming_tasks_table.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardSidebar(activeRoute: AppRoutes.dashboard),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.dashboardGradientTop, AppColors.dashboardGradientBottom],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DashboardTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 32),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 1238,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Dashboard', style: AppTypography.dashboardTitle),
                                const SizedBox(height: 28),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (final metric in _summaryMetrics)
                                      SizedBox(
                                        width: 262,
                                        height: 110,
                                        child: DashboardSummaryCard(
                                          title: metric.title,
                                          value: metric.value,
                                          icon: metric.icon,
                                          iconBackground: metric.iconBackground,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                Container(
                                  width: 1238,
                                  height: 178,
                                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.quickActionsContainer,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppColors.summaryCardBorder),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.shadow,
                                        blurRadius: 20,
                                        offset: Offset(0, 14),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Quick Actions',
                                        style: AppTypography.sectionTitle.copyWith(
                                          color: AppColors.quickActionsTitle,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          for (final action in _quickActions)
                                            SizedBox(
                                              width: 254,
                                              height: 92,
                                              child: QuickActionButton(
                                                label: action.label,
                                                icon: action.icon,
                                                color: action.color,
                                                onTap: action.onTap,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 36),
                                SizedBox(
                                  width: 1238,
                                  child: UpcomingTasksTable(tasks: _upcomingTasks),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
