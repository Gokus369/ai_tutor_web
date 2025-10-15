import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class ReportsDemoData {
  ReportsDemoData._();

  static ReportsData build() {
    return ReportsData(
      classOptions: const ['Class 12', 'Class 11', 'Class 10', 'Class 9'],
      initialClass: 'Class 10',
      metrics: const [
        ReportMetric(
          title: 'Syllabus Completion',
          value: '65%',
          icon: Icons.menu_book_outlined,
          iconColor: AppColors.accentPurple,
          iconBackground: Color(0x1F9810FA),
        ),
        ReportMetric(
          title: 'Pass Rate',
          value: '75%',
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.accentGreen,
          iconBackground: Color(0x2900A63E),
        ),
        ReportMetric(
          title: 'Needs Attention',
          value: '5',
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.accentOrange,
          iconBackground: Color(0x29F54900),
        ),
      ],
      subjects: const [
        SubjectProgress(subject: 'Mathematics', progress: 0.85),
        SubjectProgress(subject: 'Physics', progress: 0.72),
        SubjectProgress(subject: 'Chemistry', progress: 0.64),
        SubjectProgress(subject: 'Biology', progress: 0.83),
        SubjectProgress(subject: 'Social Studies', progress: 0.92),
        SubjectProgress(subject: 'English', progress: 0.56),
      ],
    );
  }
}
