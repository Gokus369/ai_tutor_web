import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/domain/models/upcoming_task.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// Static demo data used to render the dashboard UI.
class DashboardDemoData {
  DashboardDemoData._();

  static const List<DashboardSummary> summaries = [
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

  static const List<QuickAction> actions = [
    QuickAction(
      label: 'Create Class',
      icon: Icons.add,
      color: AppColors.quickActionBlue,
      type: QuickActionType.createClass,
    ),
    QuickAction(
      label: 'Add Lesson',
      icon: Icons.calendar_today_outlined,
      color: AppColors.quickActionGreen,
      type: QuickActionType.addLesson,
    ),
    QuickAction(
      label: 'Assign Quiz',
      icon: Icons.assignment_outlined,
      color: AppColors.quickActionPurple,
      type: QuickActionType.assignQuiz,
    ),
    QuickAction(
      label: 'Send Announcement',
      icon: Icons.campaign_outlined,
      color: AppColors.quickActionOrange,
      type: QuickActionType.sendAnnouncement,
    ),
  ];

  static final List<UpcomingTask> upcomingTasks = [
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

  static const List<String> classBoardOptions = ['CBSE', 'ICSE', 'State Board'];

  static const List<String> announcementRecipients = [
    'All Students',
    'All Parents',
    'Class 12',
    'Class 11',
    'Class 10',
    'Class 9',
  ];

  static const List<String> quizSubjects = [
    'Select Subject',
    'Mathematics',
    'Science',
    'History',
    'English',
  ];

  static const List<String> quizTopics = [
    'Select Topic',
    'Algebra',
    'Trigonometry',
    'World Wars',
    'Grammar',
  ];

  static const List<String> quizAssignTo = [
    'Select',
    'Entire Class',
    'Selected Students',
  ];

  static const List<String> quizClasses = [
    'Select',
    'Class 12',
    'Class 11',
    'Class 10',
    'Class 9',
  ];
}
