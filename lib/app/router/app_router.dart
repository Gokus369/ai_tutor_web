import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/auth_repository.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/ai_tutor_screen.dart';
import 'package:ai_tutor_web/features/assessments/presentation/assessments_screen.dart';
import 'package:ai_tutor_web/features/attendance/presentation/attendance_screen.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/class_details_screen.dart';
import 'package:ai_tutor_web/features/classes/presentation/classes_screen.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/instructor_cohort_screen.dart';
import 'package:ai_tutor_web/features/lessons/presentation/lessons_planner_screen.dart';
import 'package:ai_tutor_web/features/legal/presentation/privacy_policy_screen.dart';
import 'package:ai_tutor_web/features/legal/presentation/terms_of_use_screen.dart';
import 'package:ai_tutor_web/features/media/presentation/media_management_screen.dart';
import 'package:ai_tutor_web/features/notifications/presentation/notifications_screen.dart';
import 'package:ai_tutor_web/features/progress/data/progress_demo_data.dart';
import 'package:ai_tutor_web/features/progress/presentation/progress_screen.dart';
import 'package:ai_tutor_web/features/reports/presentation/reports_screen.dart';
import 'package:ai_tutor_web/features/settings/presentation/settings_screen.dart';
import 'package:ai_tutor_web/features/students/presentation/students_screen.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/syllabus_screen.dart';
import 'package:ai_tutor_web/screens/login_screen.dart';
import 'package:ai_tutor_web/features/auth/presentation/signup_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required AuthRepository repository})
    : router = GoRouter(
        initialLocation: AppRoutes.signup,
        routes: [
          GoRoute(
            path: AppRoutes.signup,
            builder: (context, state) => SignupScreen(repository: repository),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => LoginScreen(repository: repository),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.classes,
            builder: (context, state) => const ClassesScreen(),
          ),
          GoRoute(
            path: AppRoutes.syllabus,
            builder: (context, state) => const SyllabusScreen(),
          ),
          GoRoute(
            path: AppRoutes.students,
            builder: (context, state) => const StudentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.aiTutor,
            builder: (context, state) => const AiTutorScreen(),
          ),
          GoRoute(
            path: AppRoutes.lessons,
            builder: (context, state) => const LessonsPlannerScreen(),
          ),
          GoRoute(
            path: AppRoutes.attendance,
            builder: (context, state) => const AttendanceScreen(),
          ),
          GoRoute(
            path: AppRoutes.progress,
            builder: (context, state) =>
                ProgressScreen(data: ProgressDemoData.build()),
          ),
          GoRoute(
            path: AppRoutes.mediaManagement,
            builder: (context, state) => const MediaManagementScreen(),
          ),
          GoRoute(
            path: AppRoutes.instructorCohort,
            builder: (context, state) => const InstructorCohortScreen(),
          ),
          GoRoute(
            path: AppRoutes.assessments,
            builder: (context, state) => AssessmentsScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (context, state) => NotificationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (context, state) => ReportsScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.termsOfUse,
            builder: (context, state) => const TermsOfUseScreen(),
          ),
          GoRoute(
            path: AppRoutes.privacyPolicy,
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: AppRoutes.classDetails,
            builder: (context, state) {
              final extra = state.extra;
              final classInfo = extra is ClassInfo ? extra : null;
              return ClassDetailsScreen(initialInfo: classInfo);
            },
          ),
        ],
      );

  final GoRouter router;
}
