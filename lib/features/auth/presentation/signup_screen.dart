import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/form_field_label.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/signup_header.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/terms_and_policy_checkbox.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double desiredWidth = 558;
          const double desiredHeight = 1060;

          final double maxWidth = constraints.maxWidth;
          final double horizontalPadding =
              maxWidth > desiredWidth ? (maxWidth - desiredWidth) / 2 : 16;
          final double clampedSidePadding =
              (horizontalPadding * 2).clamp(0.0, maxWidth);
          final double availableWidth = maxWidth - clampedSidePadding;
          final double cardWidth =
              availableWidth > 0 ? availableWidth.clamp(0.0, desiredWidth) : desiredWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 160,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: 48,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: cardWidth,
                  height: desiredHeight,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 24,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
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
                          ),
                          const SizedBox(height: 18),
                          const FormFieldLabel(text: 'Confirm Password'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_showConfirmPassword,
                            decoration: InputDecoration(
                              hintText: 'Confirm your password',
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
                            onTermsTap: () {
                              // TODO: Navigate to terms of use
                            },
                            onPrivacyTap: () {
                              // TODO: Navigate to privacy policy
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 38,
                            child: ElevatedButton(
                              onPressed: _acceptTerms ? _onSubmit : null,
                              child: const Text('Create Account'),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 4,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: AppTypography.bodySmall.copyWith(fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushReplacementNamed(AppRoutes.login),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Login',
                                    style: AppTypography.linkSmall.copyWith(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    // TODO: Handle actual sign-up logic.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully!')),
    );
  }
}
