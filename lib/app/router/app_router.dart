import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/auth_repository.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/ai_tutor_screen.dart';
import 'package:ai_tutor_web/features/assessments/presentation/assessments_screen.dart';
import 'package:ai_tutor_web/features/attendance/presentation/attendance_screen.dart';
import 'package:ai_tutor_web/features/auth/presentation/login_screen.dart';
import 'package:ai_tutor_web/features/auth/presentation/reset_password_screen.dart';
import 'package:ai_tutor_web/features/auth/presentation/signup_screen.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/class_details_screen.dart';
import 'package:ai_tutor_web/features/classes/presentation/classes_screen.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/instructor_cohort_screen.dart';
import 'package:ai_tutor_web/features/legal/presentation/privacy_policy_screen.dart';
import 'package:ai_tutor_web/features/legal/presentation/terms_of_use_screen.dart';
import 'package:ai_tutor_web/features/lessons/presentation/lessons_planner_screen.dart';
import 'package:ai_tutor_web/features/media/presentation/media_management_screen.dart';
import 'package:ai_tutor_web/features/notifications/presentation/notifications_screen.dart';
import 'package:ai_tutor_web/features/progress/data/progress_demo_data.dart';
import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';
import 'package:ai_tutor_web/features/progress/presentation/progress_screen.dart';
import 'package:ai_tutor_web/features/reports/presentation/reports_screen.dart';
import 'package:ai_tutor_web/features/settings/presentation/settings_screen.dart';
import 'package:ai_tutor_web/features/students/presentation/students_screen.dart';
import 'package:ai_tutor_web/features/schools/presentation/schools_screen.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/syllabus_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthRepository repository;
  late final GoRouter router;
  final ProgressPageData _progressData;

  AppRouter({required this.repository, ProgressPageData? progressData}) : _progressData = progressData ?? ProgressDemoData.build() {
    router = GoRouter(
      initialLocation: repository.currentUser == null ? AppRoutes.login : AppRoutes.dashboard,
      refreshListenable: repository.authState,
      redirect: (context, state) {
        final loggedIn = repository.currentUser != null;
        final isAuth = [AppRoutes.login, AppRoutes.signup, AppRoutes.resetPassword].contains(state.uri.path);
        final isPublic = [AppRoutes.termsOfUse, AppRoutes.privacyPolicy].any((r) => state.uri.path.startsWith(r));
        if (!loggedIn && !isAuth && !isPublic) return AppRoutes.login;
        if (loggedIn && isAuth) return AppRoutes.dashboard;
        return null;
      },
      errorBuilder: (c, s) => _RouteErrorScreen(message: s.error?.toString(), loggedIn: repository.currentUser != null),
      routes: [
        _r('signup', AppRoutes.signup, (c, s) => const SignupScreen()),
        _r('login', AppRoutes.login, (c, s) => const LoginScreen()),
        _r('reset-password', AppRoutes.resetPassword, (c, s) => ResetPasswordScreen(repository: repository, initialEmail: s.uri.queryParameters['email'] ?? (s.extra as String?))),
        _r('dashboard', AppRoutes.dashboard, (c, s) => const DashboardScreen()),
        _r('classes', AppRoutes.classes, (c, s) => const ClassesScreen()),
        _r('schools', AppRoutes.schools, (c, s) => const SchoolsScreen()),
        _r('syllabus', AppRoutes.syllabus, (c, s) => const SyllabusScreen()),
        _r('students', AppRoutes.students, (c, s) => const StudentsScreen()),
        _r('aiTutor', AppRoutes.aiTutor, (c, s) => const AiTutorScreen()),
        _r('lessons', AppRoutes.lessons, (c, s) => const LessonsPlannerScreen()),
        _r('attendance', AppRoutes.attendance, (c, s) => const AttendanceScreen()),
        _r('progress', AppRoutes.progress, (c, s) => ProgressScreen(data: _progressData)),
        _r('media-management', AppRoutes.mediaManagement, (c, s) => const MediaManagementScreen()),
        _r('instructor-cohort', AppRoutes.instructorCohort, (c, s) => const InstructorCohortScreen()),
        _r('assessments', AppRoutes.assessments, (c, s) => AssessmentsScreen()),
        _r('notifications', AppRoutes.notifications, (c, s) => NotificationsScreen()),
        _r('reports', AppRoutes.reports, (c, s) => ReportsScreen()),
        _r('settings', AppRoutes.settings, (c, s) => SettingsScreen(repository: repository)),
        _r('terms', AppRoutes.termsOfUse, (c, s) => const TermsOfUseScreen()),
        _r('privacy', AppRoutes.privacyPolicy, (c, s) => const PrivacyPolicyScreen()),
        GoRoute(name: 'class-details', path: AppRoutes.classDetails, redirect: (c, s) => s.extra is! ClassInfo ? AppRoutes.classes : null, builder: (c, s) => ClassDetailsScreen(initialInfo: s.extra as ClassInfo)),
      ],
    );
  }
  GoRoute _r(String name, String path, Widget Function(BuildContext, GoRouterState) builder) => GoRoute(name: name, path: path, builder: builder);
}

class _RouteErrorScreen extends StatelessWidget {
  final String? message; final bool loggedIn;
  const _RouteErrorScreen({this.message, required this.loggedIn});
  @override Widget build(BuildContext context) => Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
    Text('Something went wrong', style: Theme.of(context).textTheme.headlineSmall),
    if (message != null) Text(message!),
    ElevatedButton(onPressed: () => GoRouter.of(context).go(loggedIn ? AppRoutes.dashboard : AppRoutes.login), child: Text(loggedIn ? 'Back' : 'Login'))
  ])));
}
