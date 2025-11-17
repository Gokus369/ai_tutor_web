import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/instructor_cohort/domain/models/cohort_metric.dart';
import 'package:ai_tutor_web/features/instructor_cohort/domain/models/learner_progress.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/widgets/class_completion_card.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/widgets/cohort_metrics_row.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/widgets/instructor_cohort_header.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class InstructorCohortScreen extends StatefulWidget {
  const InstructorCohortScreen({super.key});

  @override
  State<InstructorCohortScreen> createState() => _InstructorCohortScreenState();
}

const List<String> _classOptions = [
  'All Class',
  'Class 10',
  'Class 11',
  'Class 12',
];

const List<String> _topicOptions = [
  'All Topics',
  'Mathematics',
  'Science',
  'History',
  'English',
];

final List<CohortMetric> _metrics = [
  CohortMetric(
    label: 'Class Completion',
    value: '72%',
    description: 'Class completion percentage',
    icon: Icons.check_circle_outline,
    iconBackground: AppColors.quickActionGreen,
  ),
  CohortMetric(
    label: 'Average Quiz Score',
    value: '81%',
    description: 'Average quiz score this month',
    icon: Icons.timer_outlined,
    iconBackground: AppColors.quickActionOrange,
  ),
  CohortMetric(
    label: 'Attendance Rate',
    value: '89%',
    description: 'Average attendance rate',
    icon: Icons.people_outline,
    iconBackground: AppColors.quickActionPurple,
  ),
  CohortMetric(
    label: 'Active Learners',
    value: '28/32',
    description: 'Students with 80%+ completion',
    icon: Icons.trending_up_outlined,
    iconBackground: AppColors.quickActionBlue,
  ),
];

final List<LearnerProgress> _learners = [
  LearnerProgress(name: 'Priya Sharma', completionPercent: 94),
  LearnerProgress(name: 'Arjun Patel', completionPercent: 91),
  LearnerProgress(name: 'Sneha Reddy', completionPercent: 88),
  LearnerProgress(name: 'Ravi Mehta', completionPercent: 82),
  LearnerProgress(name: 'Anita Das', completionPercent: 71),
  LearnerProgress(name: 'Vikram Joshi', completionPercent: 62),
  LearnerProgress(name: 'Pooja Agarwal', completionPercent: 53),
];

class _InstructorCohortScreenState extends State<InstructorCohortScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedClass = _classOptions.first;
  String _selectedTopic = _topicOptions.first;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.instructorCohort,
      title: 'Instructor Cohort',
      headerBuilder: (context, shell) {
        final bool isCompact = shell.contentWidth < 900;
        return InstructorCohortHeader(
          title: 'Instructor Cohort',
          searchController: _searchController,
          classOptions: _classOptions,
          topicOptions: _topicOptions,
          selectedClass: _selectedClass,
          selectedTopic: _selectedTopic,
          isCompact: isCompact,
          onClassChanged: (value) => setState(() => _selectedClass = value),
          onTopicChanged: (value) => setState(() => _selectedTopic = value),
          onDownloadReport: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download report tapped')),
            );
          },
        );
      },
      builder: (context, shell) {
        final bool isCompact = shell.contentWidth < 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CohortMetricsRow(metrics: _metrics, isCompact: isCompact),
            const SizedBox(height: 28),
            ClassCompletionCard(learners: _learners, isCompact: isCompact),
          ],
        );
      },
    );
  }
}
