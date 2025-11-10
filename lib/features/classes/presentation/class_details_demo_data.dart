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

  static final List<SyllabusSubject> syllabusSubjects = [
    SyllabusSubject(
      id: 'math',
      title: 'Mathematics',
      status: SyllabusStatus.inProgress,
      modules: [
        SyllabusModule(
          id: 'math-linear',
          title: 'Linear Equations',
          topics: const [
            SyllabusTopic(
              title: 'Chapter 1; Linear Equations (10/15 topics)',
              progress: 0.62,
            ),
            SyllabusTopic(
              title: 'Chapter 2; Function & Graphs (5/8 topics)',
              progress: 0.46,
            ),
            SyllabusTopic(
              title: 'Chapter 3; Variables and Constants (9/10 topics)',
              progress: 0.77,
            ),
          ],
        ),
        const SyllabusModule(
          id: 'math-geometry',
          title: 'Geometry',
          topics: [],
        ),
        const SyllabusModule(
          id: 'math-algebra',
          title: 'Algebra',
          topics: [],
        ),
      ],
    ),
    const SyllabusSubject(
      id: 'physics',
      title: 'Physics',
      status: SyllabusStatus.inProgress,
      modules: [
        SyllabusModule(id: 'physics-module', title: 'Electricity', topics: []),
      ],
    ),
    const SyllabusSubject(
      id: 'english',
      title: 'English',
      status: SyllabusStatus.inProgress,
      modules: [
        SyllabusModule(id: 'english-module', title: 'Literature Review', topics: []),
      ],
    ),
    const SyllabusSubject(
      id: 'social-science',
      title: 'Social Science',
      status: SyllabusStatus.completed,
      modules: [
        SyllabusModule(id: 'ss-module', title: 'History', topics: []),
      ],
    ),
  ];

  static final List<ProgressOverview> progressOverview = [
    const ProgressOverview(subject: 'Mathematics', completion: 0.73),
    const ProgressOverview(subject: 'Physics', completion: 0.58),
    const ProgressOverview(subject: 'Biology', completion: 0.69),
    const ProgressOverview(subject: 'Chemistry', completion: 0.87),
    const ProgressOverview(subject: 'English', completion: 0.81),
    const ProgressOverview(subject: 'Social Science', completion: 0.44),
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

class SyllabusSubject {
  const SyllabusSubject({
    required this.id,
    required this.title,
    required this.status,
    required this.modules,
  });

  final String id;
  final String title;
  final SyllabusStatus status;
  final List<SyllabusModule> modules;
}

enum SyllabusStatus { inProgress, completed }

class SyllabusModule {
  const SyllabusModule({
    required this.id,
    required this.title,
    required this.topics,
  });

  final String id;
  final String title;
  final List<SyllabusTopic> topics;
}

class SyllabusTopic {
  const SyllabusTopic({required this.title, required this.progress});

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
