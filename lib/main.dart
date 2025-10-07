import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'auth_repository.dart';
import 'screens/login_screen.dart';

import 'features/auth/presentation/signup_screen.dart';

void main() {
  runApp(const AiTutorApp());
}

class AiTutorApp extends StatelessWidget {
  const AiTutorApp({super.key, required this.repository});
  final AuthRepository repository;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

