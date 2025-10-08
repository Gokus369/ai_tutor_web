import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'auth_repository.dart';
import 'features/auth/presentation/signup_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/classes/presentation/classes_screen.dart';
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
        AppRoutes.signup: (_) => const SignupScreen(),
        AppRoutes.login: (_) => LoginScreen(repository: repository),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
        AppRoutes.classes: (_) => const ClassesScreen(),
      },
    );
  }
}
