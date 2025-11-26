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
  final AuthRepository repository;
  const LoginScreen({super.key, required this.repository});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(), _idCtrl = TextEditingController(), _passCtrl = TextEditingController();
  bool _obscure = true, _loading = false;

  @override void dispose() { _idCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  void _msg(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  Future<void> _do(Future<UserAccount> Function() f) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try { final u = await f(); if(mounted) { _msg('Welcome ${u.displayName}'); context.go(AppRoutes.dashboard); } }
    catch (e) { if(mounted) _msg(e.toString().replaceAll('Exception: ', '')); }
    finally { if(mounted) setState(() => _loading = false); }
  }

  @override Widget build(BuildContext context) => AuthPageScaffold(
    desiredWidth: 480, cardPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36), tallScreenBreakpoint: 760, topPaddingLarge: 120, topPaddingSmall: 64, bottomPaddingLarge: 72, bottomPaddingSmall: 40,
    child: Form(key: _formKey, autovalidateMode: AutovalidateMode.onUserInteraction, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('AiTutor', textAlign: TextAlign.center, style: AppTypography.brandWordmark),
      const SizedBox(height: 8), Text('Welcome back', textAlign: TextAlign.center, style: AppTypography.signupTitle),
      const SizedBox(height: 28), const FormFieldLabel(text: 'Email or Username'), const SizedBox(height: 6),
      TextFormField(controller: _idCtrl, autofillHints: const [AutofillHints.username], textInputAction: TextInputAction.next,
        validator: (v) => (v ?? '').trim().isEmpty ? 'Required' : null, decoration: const InputDecoration(hintText: 'you@example.com')),
      const SizedBox(height: 18), const FormFieldLabel(text: 'Password'), const SizedBox(height: 6),
      TextFormField(controller: _passCtrl, obscureText: _obscure, autofillHints: const [AutofillHints.password], onFieldSubmitted: (_) => _do(() => widget.repository.loginWithEmail(_idCtrl.text, _passCtrl.text)),
        validator: (v) => (v ?? '').length < 8 ? 'Min 8 chars' : null,
        decoration: InputDecoration(hintText: 'Password', suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.iconMuted), onPressed: () => setState(() => _obscure = !_obscure)))),
      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _loading ? null : () => context.push('${AppRoutes.resetPassword}?email=${Uri.encodeComponent(_idCtrl.text)}'), child: Text('Forgot Password?', style: AppTypography.linkSmall))),
      const SizedBox(height: 24), AuthPrimaryButton(label: 'Login', loading: _loading, onPressed: () => _do(() => widget.repository.loginWithEmail(_idCtrl.text, _passCtrl.text))),
      const SizedBox(height: 24), const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('Or continue with', style: TextStyle(color: AppColors.textMuted, fontSize: 12))), Expanded(child: Divider())]),
      const SizedBox(height: 18), Row(children: [
        Expanded(child: AuthProviderButton(label: 'Google', enabled: !_loading, icon: const FaIcon(FontAwesomeIcons.google, size: 18), onPressed: () => _do(widget.repository.loginWithGoogle))),
        const SizedBox(width: 12),
        Expanded(child: AuthProviderButton(label: 'Microsoft', enabled: !_loading, icon: const FaIcon(FontAwesomeIcons.microsoft, size: 18), onPressed: () => _msg('Hook to Azure AD'))),
      ]),
      const SizedBox(height: 24), AuthRedirectText(prompt: "No account?", actionLabel: 'Create one', onTap: _loading ? null : () => context.go(AppRoutes.signup)),
    ])),
  );
}
