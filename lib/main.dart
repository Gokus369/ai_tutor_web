import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'auth_repository.dart';
import 'features/auth/presentation/signup_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/classes/presentation/classes_screen.dart';
import 'features/ai_tutor/presentation/ai_tutor_screen.dart';
import 'features/attendance/presentation/attendance_screen.dart';
import 'features/lessons/presentation/lessons_planner_screen.dart';
import 'features/progress/data/progress_demo_data.dart';
import 'features/progress/presentation/progress_screen.dart';
import 'features/assessments/presentation/assessments_screen.dart';
import 'features/legal/presentation/privacy_policy_screen.dart';
import 'features/legal/presentation/terms_of_use_screen.dart';
import 'features/notifications/presentation/notifications_screen.dart';
import 'features/reports/presentation/reports_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/students/presentation/students_screen.dart';
import 'features/syllabus/presentation/syllabus_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp(repository: MockAuthRepository()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});

  final AuthRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AiTutor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.signup,
      routes: {
        AppRoutes.signup: (_) => SignupScreen(repository: repository),
        AppRoutes.login: (_) => LoginScreen(repository: repository),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
        AppRoutes.classes: (_) => const ClassesScreen(),
        AppRoutes.syllabus: (_) => const SyllabusScreen(),
        AppRoutes.students: (_) => const StudentsScreen(),
        AppRoutes.aiTutor: (_) => const AiTutorScreen(),
        AppRoutes.lessons: (_) => const LessonsPlannerScreen(),
        AppRoutes.attendance: (_) => const AttendanceScreen(),
        AppRoutes.progress: (_) =>
            ProgressScreen(data: ProgressDemoData.build()),
        AppRoutes.assessments: (_) => AssessmentsScreen(),
        AppRoutes.notifications: (_) => NotificationsScreen(),
        AppRoutes.reports: (_) => ReportsScreen(),
        AppRoutes.settings: (_) => SettingsScreen(),
        AppRoutes.termsOfUse: (_) => const TermsOfUseScreen(),
        AppRoutes.privacyPolicy: (_) => const PrivacyPolicyScreen(),
      },
    );
  }
}
