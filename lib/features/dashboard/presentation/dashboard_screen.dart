import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/dashboard_demo_data.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_lesson_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/assign_quiz_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/create_class_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_quick_actions.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_summary_section.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/send_announcement_dialog.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/upcoming_tasks_table.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  List<DashboardSummary> get _summaryMetrics => DashboardDemoData.summaries;

  List<UpcomingTask> get _upcomingTasks => DashboardDemoData.upcomingTasks;

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.dashboard,
      title: 'Dashboard',
      builder: (context, shell) {
        final double width = shell.contentWidth;
        final actions = _buildQuickActions(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
    final handlerMap = _quickActionHandlers(context);
    return DashboardDemoData.actions.map((action) {
      final onTap = action.type != null ? handlerMap[action.type] : null;
      return QuickAction(
        label: action.label,
        icon: action.icon,
        color: action.color,
        type: action.type,
        onTap: onTap,
      );
    }).toList();
  }

  Map<QuickActionType, VoidCallback> _quickActionHandlers(
    BuildContext context,
  ) {
    return {
      QuickActionType.createClass: () =>
          _showDialogWithMessage<CreateClassRequest>(
            context: context,
            builder: (_) => CreateClassDialog(
              boardOptions: DashboardDemoData.classBoardOptions,
            ),
            messageBuilder: (request) => 'Class "${request.className}" created',
          ),
      QuickActionType.assignQuiz: () =>
          _showDialogWithMessage<AssignQuizRequest>(
            context: context,
            builder: (_) => const AssignQuizDialog(
              subjectOptions: DashboardDemoData.quizSubjects,
              topicOptions: DashboardDemoData.quizTopics,
              assignToOptions: DashboardDemoData.quizAssignTo,
              classOptions: DashboardDemoData.quizClasses,
            ),
            messageBuilder: (result) =>
                'Quiz "${result.title}" assigned to ${result.assignTo}',
          ),
      QuickActionType.sendAnnouncement: () =>
          _showDialogWithMessage<SendAnnouncementRequest>(
            context: context,
            builder: (_) => const SendAnnouncementDialog(
              recipientOptions: DashboardDemoData.announcementRecipients,
            ),
            messageBuilder: (result) =>
                'Announcement sent to ${result.recipient}',
          ),
      QuickActionType.addLesson: () => _showDialogWithMessage<AddLessonRequest>(
        context: context,
        builder: (_) => AddLessonDialog(
          subjectOptions: DashboardDemoData.quizSubjects,
          classOptions: DashboardDemoData.quizClasses,
        ),
        messageBuilder: (lesson) =>
            'Lesson "${lesson.lessonTitle}" added for ${lesson.className}',
      ),
    };
  }

  Future<void> _showDialogWithMessage<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    required String Function(T result) messageBuilder,
  }) async {
    final result = await showDialog<T>(context: context, builder: builder);
    if (result == null || !context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(messageBuilder(result))));
  }
}
