import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_top_bar.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_progress.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_subject.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_progress_panel.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_subject_card.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DashboardSidebar(activeRoute: AppRoutes.syllabus),
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
                            width: 1200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Syllabus', style: AppTypography.dashboardTitle),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    const SizedBox(width: 568, child: _SearchField()),
                                    const Spacer(),
                                    SizedBox(width: 163, height: 50, child: _AddSubjectButton()),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(width: 180, height: 44, child: _ClassSelector()),
                                ),
                                const SizedBox(height: 28),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 716,
                                      child: Column(
                                        children: [
                                          for (int i = 0; i < _subjects.length; i++) ...[
                                            SyllabusSubjectCard(
                                              subject: _subjects[i],
                                              expanded: i == _expandedIndex,
                                              onToggle: () {
                                                setState(() {
                                                  _expandedIndex = i == _expandedIndex ? -1 : i;
                                                });
                                              },
                                            ),
                                            if (i != _subjects.length - 1) const SizedBox(height: 20),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 32),
                                    SyllabusProgressPanel(entries: _progressEntries),
                                  ],
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

class _SearchField extends StatelessWidget {
  const _SearchField({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by subjects, chapter or topic...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: AppColors.syllabusSearchBackground,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.syllabusSearchBorder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}

class _AddSubjectButton extends StatelessWidget {
  const _AddSubjectButton({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: AppTypography.button,
      ),
      child: const Text('+ Add Subject'),
    );
  }
}

class _ClassSelector extends StatefulWidget {
  const _ClassSelector({super.key});
  @override
  State<_ClassSelector> createState() => _ClassSelectorState();
}

class _ClassSelectorState extends State<_ClassSelector> {
  String _value = 'Class 10';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.syllabusBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.syllabusSearchBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<String>(
            value: _value,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
            style: AppTypography.classCardMeta,
            isExpanded: true,
            onChanged: (value) => setState(() => _value = value ?? _value),
            items: const [
              DropdownMenuItem(value: 'Class 10', child: Text('Class 10')),
              DropdownMenuItem(value: 'Class 11', child: Text('Class 11')),
              DropdownMenuItem(value: 'Class 12', child: Text('Class 12')),
            ],
          ),
        ),
      ),
    );
  }
}
