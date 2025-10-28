import 'package:ai_tutor_web/features/dashboard/domain/models/dashboard_summary.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ClassDetailsDemoData {
  ClassDetailsDemoData._();

  static const String className = 'Class 12';

  static const List<DashboardSummary> summaries = [
    DashboardSummary(
      title: 'Total Students',
      value: '40',
      icon: Icons.people_outline,
      iconBackground: AppColors.metricIconBlue,
    ),
    DashboardSummary(
      title: 'Syllabus Progress',
      value: '65%',
      icon: Icons.menu_book_outlined,
      iconBackground: AppColors.metricIconGreen,
    ),
    DashboardSummary(
      title: 'Pending Assignments',
      value: '4',
      icon: Icons.assignment_outlined,
      iconBackground: AppColors.metricIconYellow,
    ),
    DashboardSummary(
      title: 'Needs Attention',
      value: '3',
      icon: Icons.flag_outlined,
      iconBackground: AppColors.metricIconPeach,
    ),
  ];

  static final List<ClassStudentRow> students = [
    const ClassStudentRow(
      name: 'Rowan Hahn',
      rollNo: 1,
      attendancePercent: 92,
      progressPercent: 85,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const ClassStudentRow(
      name: 'Giovanni Fields',
      rollNo: 2,
      attendancePercent: 86,
      progressPercent: 46,
      performance: StudentPerformance.needAttention,
      status: StudentStatus.active,
    ),
    const ClassStudentRow(
      name: 'Rowen Holland',
      rollNo: 3,
      attendancePercent: 91,
      progressPercent: 58,
      performance: StudentPerformance.average,
      status: StudentStatus.active,
    ),
    const ClassStudentRow(
      name: 'Celeste Moore',
      rollNo: 4,
      attendancePercent: 70,
      progressPercent: 52,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const ClassStudentRow(
      name: 'Matteo Nelson',
      rollNo: 5,
      attendancePercent: 65,
      progressPercent: 79,
      performance: StudentPerformance.average,
      status: StudentStatus.active,
    ),
    const ClassStudentRow(
      name: 'Elise Gill',
      rollNo: 6,
      attendancePercent: 73,
      progressPercent: 90,
      performance: StudentPerformance.topPerformer,
      status: StudentStatus.active,
    ),
    const ClassStudentRow(
      name: 'Gerardo Dillon',
      rollNo: 7,
      attendancePercent: 97,
      progressPercent: 33,
      performance: StudentPerformance.needAttention,
      status: StudentStatus.inactive,
    ),
  ];

  static final List<SubjectProgress> subjectProgress = [
    SubjectProgress(
      subject: 'Mathematics',
      overallProgress: 0.62,
      topics: [
        const TopicProgress('Linear Equations (10/16)', 0.62),
        const TopicProgress('Function & Graphs (5/8)', 0.46),
        const TopicProgress('Variables and Constants', 0.77),
      ],
    ),
    SubjectProgress(
      subject: 'Physics',
      overallProgress: 0.55,
      topics: [
        const TopicProgress('Kinematics', 0.60),
        const TopicProgress('Dynamics', 0.50),
      ],
    ),
    SubjectProgress(
      subject: 'English',
      overallProgress: 0.48,
      topics: [
        const TopicProgress('Literature', 0.58),
        const TopicProgress('Grammar', 0.38),
      ],
    ),
  ];

  static final List<ProgressOverview> progressOverview = [
    const ProgressOverview(subject: 'Mathematics', completion: 0.73),
    const ProgressOverview(subject: 'Physics', completion: 0.59),
    const ProgressOverview(subject: 'Biology', completion: 0.60),
    const ProgressOverview(subject: 'Chemistry', completion: 0.87),
    const ProgressOverview(subject: 'English', completion: 0.81),
    const ProgressOverview(subject: 'Social Science', completion: 0.46),
  ];

  static final List<ClassAssessment> assessments = [
    ClassAssessment(
      title: 'Science Test - Matter',
      dueDate: DateTime(2025, 9, 25),
      submittedCount: 0,
      totalCount: 32,
      type: AssessmentType.test,
      status: AssessmentStatus.upcoming,
    ),
    ClassAssessment(
      title: 'Math Assignment - Polynomials',
      dueDate: DateTime(2025, 9, 12),
      submittedCount: 28,
      totalCount: 32,
      type: AssessmentType.assignment,
      status: AssessmentStatus.active,
    ),
    ClassAssessment(
      title: 'English Essay - My School',
      dueDate: DateTime(2025, 9, 12),
      submittedCount: 28,
      totalCount: 32,
      type: AssessmentType.essay,
      status: AssessmentStatus.active,
    ),
    ClassAssessment(
      title: 'Science Quiz - Chapter 1',
      dueDate: DateTime(2025, 9, 15),
      submittedCount: 28,
      totalCount: 32,
      type: AssessmentType.quiz,
      status: AssessmentStatus.completed,
    ),
  ];
}

class ClassStudentRow {
  const ClassStudentRow({
    required this.name,
    required this.rollNo,
    required this.attendancePercent,
    required this.progressPercent,
    required this.performance,
    required this.status,
  });

  final String name;
  final int rollNo;
  final int attendancePercent;
  final int progressPercent;
  final StudentPerformance performance;
  final StudentStatus status;
}

enum StudentStatus { active, inactive }

enum StudentPerformance { topPerformer, average, needAttention }

class SubjectProgress {
  SubjectProgress({
    required this.subject,
    required this.overallProgress,
    required this.topics,
  });

  final String subject;
  final double overallProgress;
  final List<TopicProgress> topics;
}

class TopicProgress {
  const TopicProgress(this.title, this.progress);

  final String title;
  final double progress;
}

class ProgressOverview {
  const ProgressOverview({required this.subject, required this.completion});

  final String subject;
  final double completion;
}

class ClassAssessment {
  ClassAssessment({
    required this.title,
    required this.dueDate,
    required this.submittedCount,
    required this.totalCount,
    required this.type,
    required this.status,
  });

  final String title;
  final DateTime dueDate;
  final int submittedCount;
  final int totalCount;
  final AssessmentType type;
  final AssessmentStatus status;
}

enum AssessmentType { test, assignment, essay, quiz }

enum AssessmentStatus { upcoming, active, completed }
