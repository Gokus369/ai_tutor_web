import 'package:ai_tutor_web/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.repository});

  static const routeName = '/login';

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
      if (!_validUsername(v)) return 'Username must be 3–30 chars (letters, numbers, _, .)';
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
      final user = await widget.repository
          .loginWithEmail(_idCtrl.text.trim(), _passCtrl.text);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${user.displayName}!')),
      );
      // TODO: Navigate to your app's home/dashboard
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reset link sent to $id')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not send reset link')));
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Signed in as ${user.displayName}')));
      // TODO: Navigate to home
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Google sign-in failed')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7F9), // soft blue/grey like the mock
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                child: AutofillGroup(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        Text('AiTutor',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: const Color(0xFF0D3B44), // deep teal
                            )),
                        const SizedBox(height: 6),
                        Text('Login',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 22),

                        // Email or Username
                        Text('Email or Username',
                            style: theme.textTheme.labelMedium),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _idCtrl,
                          focusNode: _idFocus,
                          autofillHints: const [AutofillHints.username, AutofillHints.email],
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: _idValidator,
                          onFieldSubmitted: (_) => _passFocus.requestFocus(),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Password
                        Text('Password', style: theme.textTheme.labelMedium),
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
                            hintText: '••••••••',
                            border: const OutlineInputBorder(),
                            isDense: true,
                            suffixIcon: IconButton(
                              tooltip: _obscure ? 'Show password' : 'Hide password',
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _loading ? null : _forgotPassword,
                            child: const Text('Forgot Password?'),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Login button
                        SizedBox(
                          height: 46,
                          child: FilledButton(
                            onPressed: _loading ? null : _login,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF1F646A), // teal button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text('Login'),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Divider "Or Continue with"
                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Or Continue with',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.grey.shade700,
                                  )),
                            ),
                            const Expanded(child: Divider(thickness: 1)),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Social buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _loading ? null : _googleSignIn,
                                icon: const FaIcon(FontAwesomeIcons.google, size: 18),
                                label: const Text('Google'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
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
                                icon: const FaIcon(FontAwesomeIcons.microsoft, size: 18),
                                label: const Text('Microsoft'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text("Don't have an account? ",
                                  style: theme.textTheme.bodySmall),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('Navigate to Register page')),
                                        ),
                                child: const Text('Register'),
                              )
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
        ),
      ),
    );
  }
}
