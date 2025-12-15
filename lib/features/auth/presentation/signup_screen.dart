import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/form_field_label.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/signup_header.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/terms_and_policy_checkbox.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../application/auth_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final List<String> _roles = const ['Student', 'Teacher', 'Administrator'];

  final List<String> _educationBoards = const [
    'CBSE',
    'ICSE',
    'State Board',
    'International Baccalaureate',
  ];

  final List<String> _schools = const [
    'Greenwood High School',
    'Sunrise Public School',
    'Riverdale International',
  ];

  String? _selectedRole;
  String? _selectedBoard;
  String? _selectedSchool;
  bool _acceptTerms = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _submitting = false;

  void _msg(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.registered) {
          _msg('Account created. Please login to continue.');
          context.go(AppRoutes.login);
        } else if (state.status == AuthStatus.error && state.error != null) {
          _msg(state.error!.replaceAll('Exception: ', ''));
        }
      },
      builder: (context, state) {
        _submitting = state.isLoading;
        return AuthPageScaffold(
          desiredWidth: 558,
          tallScreenBreakpoint: 820,
          topPaddingLarge: 120,
          topPaddingSmall: 72,
          bottomPaddingLarge: 72,
          bottomPaddingSmall: 40,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SignupHeader(),
                const SizedBox(height: 32),
                const FormFieldLabel(text: 'Full Name'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const FormFieldLabel(text: 'Email Address'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) {
                      return 'Enter your email';
                    }
                    final emailRegex = RegExp(r'^[\w.\-]+@[\w.\-]+\.[A-Za-z]{2,}$');
                    if (!emailRegex.hasMatch(email)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const FormFieldLabel(text: 'Password'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.iconMuted,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  validator: (value) {
                    final password = value ?? '';
                    if (password.isEmpty) {
                      return 'Enter your password';
                    }
                    if (password.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
                    final hasDigit = RegExp(r'\d').hasMatch(password);
                    if (!hasLetter || !hasDigit) {
                      return 'Include both letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const FormFieldLabel(text: 'Confirm Password'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_showConfirmPassword,
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.iconMuted,
                      ),
                      onPressed: () => setState(
                        () => _showConfirmPassword = !_showConfirmPassword,
                      ),
                    ),
                  ),
                  validator: (value) {
                    final confirmPassword = value ?? '';
                    if (confirmPassword.isEmpty) {
                      return 'Confirm your password';
                    }
                    if (confirmPassword != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const FormFieldLabel(text: 'Role'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  isExpanded: true,
                  hint: const Text('Select your role'),
                  decoration: const InputDecoration(),
                  items: _roles
                      .map(
                        (role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedRole = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const FormFieldLabel(text: 'Education Board'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedBoard,
                  isExpanded: true,
                  hint: const Text('Select your education board'),
                  decoration: const InputDecoration(),
                  items: _educationBoards
                      .map(
                        (board) => DropdownMenuItem(
                          value: board,
                          child: Text(board),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedBoard = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your education board';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const FormFieldLabel(text: 'School Name'),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSchool,
                  isExpanded: true,
                  hint: const Text('Select your school name'),
                  decoration: const InputDecoration(),
                  items: _schools
                      .map(
                        (school) => DropdownMenuItem(
                          value: school,
                          child: Text(school),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _selectedSchool = value),
                ),
                const SizedBox(height: 24),
                TermsAndPolicyCheckbox(
                  value: _acceptTerms,
                  onChanged: (value) =>
                      setState(() => _acceptTerms = value ?? false),
                  onTermsTap: () => context.push(AppRoutes.termsOfUse),
                  onPrivacyTap: () => context.push(AppRoutes.privacyPolicy),
                ),
                const SizedBox(height: 24),
                AuthPrimaryButton(
                  label: 'Create Account',
                  height: 38,
                  loading: _submitting,
                  onPressed: !_acceptTerms ? null : _onSubmit,
                ),
                const SizedBox(height: 20),
                AuthRedirectText(
                  prompt: 'Already have an account?',
                  actionLabel: 'Login',
                  onTap: () => context.go(AppRoutes.login),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _submitting = true);
    await context.read<AuthCubit>().signup(
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          role: _selectedRole ?? '',
          educationBoard: _selectedBoard ?? '',
          school: _selectedSchool ?? '',
        );
    if (mounted) {
      setState(() => _submitting = false);
    }
  }
}
