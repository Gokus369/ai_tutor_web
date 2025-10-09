import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_card.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
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
    return DashboardShell(
      activeRoute: AppRoutes.classes,
      builder: (context, shell) {
        final double width = shell.contentWidth;
        const double spacing = 24;

        final int columns;
        if (width >= 1080) {
          columns = 3;
        } else if (width >= 720) {
          columns = 2;
        } else {
          columns = 1;
        }

        final double cardWidth =
            columns == 1 ? width : (width - spacing * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Classes', style: AppTypography.dashboardTitle),
            const SizedBox(height: 24),
            Wrap(
              spacing: spacing,
              runSpacing: 24,
              children: _classes
                  .map(
                    (classInfo) => SizedBox(
                      width: cardWidth,
                      child: ClassCard(info: classInfo),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: shell.isMobile ? 16 : 0),
          ],
        );
      },
    );
  }
}
