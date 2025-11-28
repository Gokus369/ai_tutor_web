import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_progress.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_subject.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_view.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  int _expandedIndex = 0;

  static final List<SyllabusSubject> _subjects = [
    SyllabusSubject(
      title: 'Mathematics',
      status: SyllabusStatus.inProgress,
      modules: const [
        SyllabusModule(
          title: 'Linear Equations',
          completionPercentage: 0.62,
          topicSummary: 'Chapter 1: Linear Equations (10/15 Topics)',
        ),
        SyllabusModule(
          title: 'Chapter 2: Function & Graphs',
          completionPercentage: 0.46,
          topicSummary: 'Chapter 2: Function & Graphs (5/8 Topics)',
        ),
        SyllabusModule(
          title: 'Chapter 3: Variables and Constants',
          completionPercentage: 0.77,
          topicSummary: 'Chapter 3: Variables & Constants (5/10 Topics)',
        ),
      ],
      additionalTopics: const ['Geometry', 'Algebra'],
    ),
    SyllabusSubject(
      title: 'Physics',
      status: SyllabusStatus.inProgress,
      modules: const [
        SyllabusModule(
          title: 'Motion and Force',
          completionPercentage: 0.58,
          topicSummary: 'Chapter 1: Motion Basics (7/12 Topics)',
        ),
        SyllabusModule(
          title: 'Electricity Fundamentals',
          completionPercentage: 0.31,
          topicSummary: 'Chapter 2: Electrostatics (4/13 Topics)',
        ),
      ],
      additionalTopics: const ['Sound Waves'],
    ),
    SyllabusSubject(
      title: 'English',
      status: SyllabusStatus.inProgress,
      modules: const [
        SyllabusModule(
          title: 'Literature & Comprehension',
          completionPercentage: 0.54,
          topicSummary: 'Chapter 1: Poetry (6/11 Topics)',
        ),
      ],
      additionalTopics: const ['Writing Skills'],
    ),
    SyllabusSubject(
      title: 'Social Science',
      status: SyllabusStatus.completed,
      modules: const [
        SyllabusModule(
          title: 'History & Civics',
          completionPercentage: 1.0,
          topicSummary: 'Chapter 4: Indian Constitution (12/12 Topics)',
        ),
      ],
      additionalTopics: const ['Economics'],
    ),
  ];

  static final List<SyllabusProgress> _progressEntries = const [
    SyllabusProgress(subject: 'Mathematics', completionPercentage: 0.73),
    SyllabusProgress(subject: 'Physics', completionPercentage: 0.58),
    SyllabusProgress(subject: 'Biology', completionPercentage: 0.69),
    SyllabusProgress(subject: 'Chemistry', completionPercentage: 0.87),
    SyllabusProgress(subject: 'English', completionPercentage: 0.81),
    SyllabusProgress(subject: 'Social Science', completionPercentage: 0.44),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.syllabus,
      title: 'Syllabus',
      titleSpacing: 20,
      builder: (context, shell) {
        return SyllabusView(
          subjects: _subjects,
          progressEntries: _progressEntries,
          expandedIndex: _expandedIndex,
          onSubjectToggle: (index) {
            setState(() {
              _expandedIndex = index == _expandedIndex ? -1 : index;
            });
          },
        );
      },
    );
  }
}
