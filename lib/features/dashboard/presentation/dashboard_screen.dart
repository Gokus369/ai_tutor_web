import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/dashboard_demo_data.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/create_class_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_lesson_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/assign_quiz_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/send_announcement_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/upcoming_tasks_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  List<DashboardSummary> get _summaryMetrics => DashboardDemoData.summaries;

  List<UpcomingTask> get _upcomingTasks => DashboardDemoData.upcomingTasks;

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
    return DashboardDemoData.actions.map((action) {
      switch (action.type) {
        case QuickActionType.createClass:
          return QuickAction(
            label: action.label,
            icon: action.icon,
            color: action.color,
            type: action.type,
            onTap: () => _showCreateClassDialog(context),
          );
        case QuickActionType.assignQuiz:
          return QuickAction(
            label: action.label,
            icon: action.icon,
            color: action.color,
            type: action.type,
            onTap: () => _showAssignQuizDialog(context),
          );
        case QuickActionType.sendAnnouncement:
          return QuickAction(
            label: action.label,
            icon: action.icon,
            color: action.color,
            type: action.type,
            onTap: () => _showSendAnnouncementDialog(context),
          );
        case QuickActionType.addLesson:
          return QuickAction(
            label: action.label,
            icon: action.icon,
            color: action.color,
            type: action.type,
            onTap: () => _showAddLessonDialog(context),
          );
        default:
          return action;
      }
    }).toList();
  }

  Future<void> _showCreateClassDialog(BuildContext context) async {
    final request = await showDialog<CreateClassRequest>(
      context: context,
      builder: (_) =>
          CreateClassDialog(boardOptions: DashboardDemoData.classBoardOptions),
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
          builder: (_) => const SendAnnouncementDialog(
            recipientOptions: DashboardDemoData.announcementRecipients,
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
      builder: (_) => const AssignQuizDialog(
        subjectOptions: DashboardDemoData.quizSubjects,
        topicOptions: DashboardDemoData.quizTopics,
        assignToOptions: DashboardDemoData.quizAssignTo,
        classOptions: DashboardDemoData.quizClasses,
      ),
    );

    if (result == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz "${result.title}" assigned to ${result.assignTo}'),
      ),
    );
  }

  Future<void> _showAddLessonDialog(BuildContext context) async {
    final AddLessonRequest? result = await showDialog<AddLessonRequest>(
      context: context,
      builder: (_) => AddLessonDialog(
        subjectOptions: DashboardDemoData.quizSubjects,
        classOptions: DashboardDemoData.quizClasses,
      ),
    );

    if (result == null || !context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lesson "${result.lessonTitle}" added for ${result.className}'),
      ),
    );
  }
}
