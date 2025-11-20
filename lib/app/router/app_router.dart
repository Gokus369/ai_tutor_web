import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/auth_repository.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/ai_tutor_screen.dart';
import 'package:ai_tutor_web/features/assessments/presentation/assessments_screen.dart';
import 'package:ai_tutor_web/features/attendance/presentation/attendance_screen.dart';
import 'package:ai_tutor_web/features/auth/presentation/login_screen.dart';
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
import 'package:ai_tutor_web/features/syllabus/presentation/syllabus_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({required this.repository, ProgressPageData? progressData}) {
    _progressData = progressData ?? ProgressDemoData.build();
    router = GoRouter(
      initialLocation: repository.currentUser == null
          ? AppRoutes.signup
          : AppRoutes.dashboard,
      refreshListenable: repository.authState,
      redirect: (context, state) {
        final loggedIn = repository.currentUser != null;
        final location = state.uri.path;
        final accessingAuth = _isAuthRoute(location);
        final isPublic = _isPublicRoute(location);

        if (!loggedIn && !isPublic) {
          return AppRoutes.login;
        }
        if (loggedIn && accessingAuth) {
          return AppRoutes.dashboard;
        }
        return null;
      },
      errorBuilder: (context, state) => _RouteErrorScreen(
        message: state.error?.toString(),
        loggedIn: repository.currentUser != null,
      ),
      routes: [
        GoRoute(
          name: 'signup',
          path: AppRoutes.signup,
          builder: (context, state) => SignupScreen(repository: repository),
        ),
        GoRoute(
          name: 'login',
          path: AppRoutes.login,
          builder: (context, state) => LoginScreen(repository: repository),
        ),
        GoRoute(
          name: 'dashboard',
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          name: 'classes',
          path: AppRoutes.classes,
          builder: (context, state) => const ClassesScreen(),
        ),
        GoRoute(
          name: 'syllabus',
          path: AppRoutes.syllabus,
          builder: (context, state) => const SyllabusScreen(),
        ),
        GoRoute(
          name: 'students',
          path: AppRoutes.students,
          builder: (context, state) => const StudentsScreen(),
        ),
        GoRoute(
          name: 'aiTutor',
          path: AppRoutes.aiTutor,
          builder: (context, state) => const AiTutorScreen(),
        ),
        GoRoute(
          name: 'lessons',
          path: AppRoutes.lessons,
          builder: (context, state) => const LessonsPlannerScreen(),
        ),
        GoRoute(
          name: 'attendance',
          path: AppRoutes.attendance,
          builder: (context, state) => const AttendanceScreen(),
        ),
        GoRoute(
          name: 'progress',
          path: AppRoutes.progress,
          builder: (context, state) => ProgressScreen(data: _progressData),
        ),
        GoRoute(
          name: 'media-management',
          path: AppRoutes.mediaManagement,
          builder: (context, state) => const MediaManagementScreen(),
        ),
        GoRoute(
          name: 'instructor-cohort',
          path: AppRoutes.instructorCohort,
          builder: (context, state) => const InstructorCohortScreen(),
        ),
        GoRoute(
          name: 'assessments',
          path: AppRoutes.assessments,
          builder: (context, state) => AssessmentsScreen(),
        ),
        GoRoute(
          name: 'notifications',
          path: AppRoutes.notifications,
          builder: (context, state) => NotificationsScreen(),
        ),
        GoRoute(
          name: 'reports',
          path: AppRoutes.reports,
          builder: (context, state) => ReportsScreen(),
        ),
        GoRoute(
          name: 'settings',
          path: AppRoutes.settings,
          builder: (context, state) => SettingsScreen(),
        ),
        GoRoute(
          name: 'terms',
          path: AppRoutes.termsOfUse,
          builder: (context, state) => const TermsOfUseScreen(),
        ),
        GoRoute(
          name: 'privacy',
          path: AppRoutes.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyScreen(),
        ),
        GoRoute(
          name: 'class-details',
          path: AppRoutes.classDetails,
          redirect: (context, state) {
            final extra = state.extra;
            if (extra is! ClassInfo) {
              return AppRoutes.classes;
            }
            return null;
          },
          builder: (context, state) {
            final extra = state.extra;
            final classInfo = extra! as ClassInfo;
            return ClassDetailsScreen(initialInfo: classInfo);
          },
        ),
      ],
    );
  }

  final AuthRepository repository;
  late final ProgressPageData _progressData;
  late final GoRouter router;

  static const Set<String> _publicRoutes = {
    AppRoutes.signup,
    AppRoutes.login,
    AppRoutes.termsOfUse,
    AppRoutes.privacyPolicy,
  };

  bool _isPublicRoute(String location) {
    for (final route in _publicRoutes) {
      if (location == route || location.startsWith('$route/')) {
        return true;
      }
    }
    return false;
  }

  bool _isAuthRoute(String location) {
    return location == AppRoutes.login || location == AppRoutes.signup;
  }
}

class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen({this.message, required this.loggedIn});

  final String? message;
  final bool loggedIn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (message != null)
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => GoRouter.of(
                  context,
                ).go(loggedIn ? AppRoutes.dashboard : AppRoutes.login),
                child: Text(loggedIn ? 'Back to Dashboard' : 'Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
