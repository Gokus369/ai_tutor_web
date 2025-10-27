import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/create_class_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/assign_quiz_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/send_announcement_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/upcoming_tasks_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<String> _quickActionBoardOptions = [
    'CBSE',
    'ICSE',
    'State Board',
  ];

  static const List<String> _announcementRecipients = [
    'All Students',
    'All Parents',
    'Class 12',
    'Class 11',
    'Class 10',
    'Class 9',
  ];

  static const List<String> _quizSubjects = [
    'Select Subject',
    'Mathematics',
    'Science',
    'History',
    'English',
  ];

  static const List<String> _quizTopics = [
    'Select Topic',
    'Algebra',
    'Trigonometry',
    'World Wars',
    'Grammar',
  ];

  static const List<String> _quizAssignTo = [
    'Select',
    'Entire Class',
    'Selected Students',
  ];

  static const List<String> _quizClasses = [
    'Select',
    'Class 12',
    'Class 11',
    'Class 10',
    'Class 9',
  ];

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
        final actions = _buildQuickActions(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Dashboard', style: AppTypography.dashboardTitle),
            const SizedBox(height: 24),
            DashboardSummarySection(
              metrics: _summaryMetrics,
              availableWidth: width,
            ),
            const SizedBox(height: 28),
            DashboardQuickActions(
              actions: actions,
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

  List<QuickAction> _buildQuickActions(BuildContext context) {
    void showInfo(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    return [
      QuickAction(
        label: 'Create Class',
        icon: Icons.add,
        color: AppColors.quickActionBlue,
        onTap: () => _showCreateClassDialog(context),
      ),
      QuickAction(
        label: 'Add Lesson',
        icon: Icons.calendar_today_outlined,
        color: AppColors.quickActionGreen,
        onTap: () => showInfo('Add lesson coming soon'),
      ),
      QuickAction(
        label: 'Assign Quiz',
        icon: Icons.assignment_outlined,
        color: AppColors.quickActionPurple,
        onTap: () => _showAssignQuizDialog(context),
      ),
      QuickAction(
        label: 'Send Announcement',
        icon: Icons.campaign_outlined,
        color: AppColors.quickActionOrange,
        onTap: () => _showSendAnnouncementDialog(context),
      ),
    ];
  }

  Future<void> _showCreateClassDialog(BuildContext context) async {
    final request = await showDialog<CreateClassRequest>(
      context: context,
      builder: (_) => CreateClassDialog(boardOptions: _quickActionBoardOptions),
    );

    if (request == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Class "${request.className}" created')),
    );
  }

  Future<void> _showSendAnnouncementDialog(BuildContext context) async {
    final SendAnnouncementRequest? result =
        await showDialog<SendAnnouncementRequest>(
      context: context,
      builder: (_) => SendAnnouncementDialog(
        recipientOptions: _announcementRecipients,
      ),
    );

    if (result == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Announcement sent to ${result.recipient}')),
    );
  }

  Future<void> _showAssignQuizDialog(BuildContext context) async {
    final AssignQuizRequest? result = await showDialog<AssignQuizRequest>(
      context: context,
      builder: (_) => AssignQuizDialog(
        subjectOptions: _quizSubjects,
        topicOptions: _quizTopics,
        assignToOptions: _quizAssignTo,
        classOptions: _quizClasses,
      ),
    );

    if (result == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Quiz "${result.title}" assigned to ${result.assignTo}',
        ),
      ),
    );
  }
}
