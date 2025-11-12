import 'package:ai_tutor_web/app/router/app_router.dart';
import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'auth_repository.dart';

void main() {
  runApp(MyApp(repository: MockAuthRepository()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.repository})
    : _router = AppRouter(repository: repository);

  final AuthRepository repository;
  final AppRouter _router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AiTutor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router.router,
    );
  }
}
