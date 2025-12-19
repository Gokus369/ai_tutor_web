import 'package:ai_tutor_web/app/router/app_router.dart';
import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/core/network/api_client.dart';
import 'package:ai_tutor_web/core/network/api_config_cubit.dart';
import 'package:ai_tutor_web/features/auth/application/auth_cubit.dart';
import 'package:ai_tutor_web/features/schools/data/school_repository.dart';
import 'package:ai_tutor_web/features/schools/presentation/bloc/school_cubit.dart';
import 'package:ai_tutor_web/features/teachers/data/teacher_repository.dart';
import 'package:ai_tutor_web/features/teachers/presentation/bloc/teacher_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_repository.dart';

void main() {
  final apiConfig = ApiConfigCubit();
  final apiClient = ApiClient(initialConfig: apiConfig.state);
  final repository = ApiAuthRepository(apiClient: apiClient);
  final schoolsRepository = SchoolRepository(apiClient);
  final teacherRepository = TeacherRepository(apiClient);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: apiClient),
        RepositoryProvider<AuthRepository>.value(value: repository),
        RepositoryProvider<SchoolRepository>.value(value: schoolsRepository),
        RepositoryProvider<TeacherRepository>.value(value: teacherRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ApiConfigCubit>.value(value: apiConfig),
          BlocProvider<AuthCubit>(create: (context) => AuthCubit(repository)),
          BlocProvider<SchoolCubit>(
            create: (context) => SchoolCubit(schoolsRepository)..loadSchools(),
          ),
          BlocProvider<TeacherCubit>(
            create: (context) =>
                TeacherCubit(teacherRepository)..loadTeachers(),
          ),
        ],
        child: MyApp(repository: repository),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.repository})
    : _router = AppRouter(repository: repository);

  final AuthRepository repository;
  final AppRouter _router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ApiConfigCubit, ApiConfigState>(
          listenWhen: (previous, current) => previous.baseUrl != current.baseUrl,
          listener: (context, state) => context.read<ApiClient>().updateBaseUrl(state),
        ),
      ],
      child: MaterialApp.router(
        title: 'AiTutor',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        routerConfig: _router.router,
      ),
    );
  }
}
