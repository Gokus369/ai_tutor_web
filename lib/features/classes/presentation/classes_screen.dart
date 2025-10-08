import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_card.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_top_bar.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ClassesScreen extends StatelessWidget {
  const ClassesScreen({super.key});

  static final List<ClassInfo> _classes = [
    const ClassInfo(
      name: 'Class 12',
      board: 'CBSE',
      studentCount: 45,
      subjectSummary: 'Mathematics, English, Malayalam, Physics',
      syllabusProgress: 0.49,
    ),
    const ClassInfo(
      name: 'Class 11',
      board: 'CBSE',
      studentCount: 30,
      subjectSummary: 'Mathematics, English, Malayalam, Physics',
      syllabusProgress: 0.64,
    ),
    const ClassInfo(
      name: 'Class 10',
      board: 'CBSE',
      studentCount: 50,
      subjectSummary: 'Mathematics, English, Malayalam, Physics',
      syllabusProgress: 0.75,
    ),
    const ClassInfo(
      name: 'Class 9',
      board: 'CBSE',
      studentCount: 42,
      subjectSummary: 'Mathematics, English, Malayalam, Physics',
      syllabusProgress: 0.42,
    ),
    const ClassInfo(
      name: 'Class 8',
      board: 'CBSE',
      studentCount: 38,
      subjectSummary: 'Mathematics, English, Malayalam, Physics',
      syllabusProgress: 0.59,
    ),
    const ClassInfo(
      name: 'Class 7',
      board: 'CBSE',
      studentCount: 46,
      subjectSummary: 'Mathematics, English, Malayalam, Physics',
      syllabusProgress: 0.35,
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
            const DashboardSidebar(activeRoute: AppRoutes.classes),
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
                            width: 1201,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Classes', style: AppTypography.dashboardTitle),
                                const SizedBox(height: 28),
                                Wrap(
                                  spacing: 60,
                                  runSpacing: 28,
                                  children: _classes.map((classInfo) => ClassCard(info: classInfo)).toList(),
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
