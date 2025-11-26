import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/auth_repository.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/form_field_label.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.repository,
    this.initialEmail,
  });

  final AuthRepository repository;
  final String? initialEmail;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailCtrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Enter your email';
    final regex = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    if (!regex.hasMatch(email)) return 'Enter a valid email';
    return null;
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final email = _emailCtrl.text.trim();
    setState(() => _loading = true);
    try {
      await widget.repository.sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Reset link sent to $email')));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go(AppRoutes.login);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send reset link')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      desiredWidth: 560,
      cardPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 42),
      tallScreenBreakpoint: 760,
      topPaddingLarge: 120,
      topPaddingSmall: 72,
      bottomPaddingLarge: 72,
      bottomPaddingSmall: 40,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: AppTypography.signupTitle.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Text(
                "Enter the email tied to your account and we'll send you a reset link.",
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              const FormFieldLabel(text: 'Enter your Email'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailCtrl,
                autofillHints: const [AutofillHints.email],
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: _emailValidator,
                onFieldSubmitted: (_) => _sendResetLink(),
                decoration: const InputDecoration(hintText: 'you@example.com'),
              ),
              const SizedBox(height: 22),
              AuthPrimaryButton(
                label: 'Send Reset Link',
                onPressed: _loading ? null : _sendResetLink,
                loading: _loading,
                height: 46,
              ),
              const SizedBox(height: 18),
              AuthRedirectText(
                prompt: 'Remembered your password?',
                actionLabel: 'Back to Login',
                onTap: _loading ? null : () => context.go(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
