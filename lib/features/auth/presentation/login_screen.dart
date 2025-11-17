import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/auth_repository.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_page_scaffold.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_primary_button.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_provider_button.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/auth_redirect_text.dart';
import 'package:ai_tutor_web/features/auth/presentation/widgets/form_field_label.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.repository});

  final AuthRepository repository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _idFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    _idFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  bool _looksLikeEmail(String v) => v.contains('@');

  bool _validEmail(String v) {
    final r = RegExp(r'^[\w\.\-+]+@([\w\-]+\.)+[A-Za-z]{2,}$');
    return r.hasMatch(v);
  }

  bool _validUsername(String v) {
    final r = RegExp(r'^[a-zA-Z0-9_\.]{3,30}$');
    return r.hasMatch(v);
  }

  String? _idValidator(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter email or username';
    if (_looksLikeEmail(v)) {
      if (!_validEmail(v)) return 'Enter a valid email';
    } else {
      if (!_validUsername(v)) {
        return 'Username must be 3–30 chars (letters, numbers, _, .)';
      }
    }
    return null;
  }

  String? _passValidator(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Enter password';
    if (v.length < 8) return 'At least 8 characters';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(v);
    final hasDigit = RegExp(r'\d').hasMatch(v);
    if (!hasLetter || !hasDigit) return 'Include letters and numbers';
    return null;
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = await widget.repository.loginWithEmail(
        _idCtrl.text.trim(),
        _passCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Welcome, ${user.displayName}!')));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go(AppRoutes.dashboard);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final id = _idCtrl.text.trim();
    if (!_looksLikeEmail(id) || !_validEmail(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email above to reset')),
      );
      _idFocus.requestFocus();
      return;
    }
    setState(() => _loading = true);
    try {
      await widget.repository.sendPasswordReset(id);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Reset link sent to $id')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not send reset link')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      final user = await widget.repository.loginWithGoogle();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as ${user.displayName}')),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.go(AppRoutes.dashboard);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Google sign-in failed')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageScaffold(
      desiredWidth: 480,
      cardPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      tallScreenBreakpoint: 760,
      topPaddingLarge: 120,
      topPaddingSmall: 64,
      bottomPaddingLarge: 72,
      bottomPaddingSmall: 40,
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'AiTutor',
                textAlign: TextAlign.center,
                style: AppTypography.brandWordmark,
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome back',
                textAlign: TextAlign.center,
                style: AppTypography.signupTitle,
              ),
              const SizedBox(height: 28),
              const FormFieldLabel(text: 'Email or Username'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _idCtrl,
                focusNode: _idFocus,
                autofillHints: const [
                  AutofillHints.username,
                  AutofillHints.email,
                ],
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: _idValidator,
                onFieldSubmitted: (_) => _passFocus.requestFocus(),
                decoration: const InputDecoration(
                  hintText: 'you@example.com',
                ),
              ),
              const SizedBox(height: 18),
              const FormFieldLabel(text: 'Password'),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passCtrl,
                focusNode: _passFocus,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _login(),
                validator: _passValidator,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.iconMuted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading ? null : _forgotPassword,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot Password?',
                    style: AppTypography.linkSmall,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AuthPrimaryButton(
                label: 'Login',
                loading: _loading,
                onPressed: _login,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Or continue with',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: AuthProviderButton(
                      label: 'Google',
                      enabled: !_loading,
                      icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                      onPressed: _googleSignIn,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuthProviderButton(
                      label: 'Microsoft',
                      enabled: !_loading,
                      icon: const FaIcon(FontAwesomeIcons.microsoft, size: 18),
                      onPressed: _loading
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Hook this to Azure AD / Microsoft (OAuth/MSAL).',
                                  ),
                                ),
                              );
                            },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AuthRedirectText(
                prompt: "Don't have an account?",
                actionLabel: 'Create one',
                onTap:
                    _loading ? null : () => context.go(AppRoutes.signup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
