import 'package:flutter/material.dart';
import 'auth_repository.dart';
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F646A)),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Color(0xFF9AA6AC)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      home: LoginScreen(repository: repository),
    );
  }
}
