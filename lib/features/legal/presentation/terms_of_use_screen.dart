import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Use'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              'Terms of Use',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: 16),
            const Text(
              '''
Welcome to AiTutor. These terms govern your access to and use of our products, services, and applications. By creating an account or continuing to use AiTutor, you agree to the following:

- You are responsible for maintaining the confidentiality of your account credentials.
- You agree not to misuse the service, including attempting to access data you are not authorised to view.
- Content you upload should comply with applicable laws and must not infringe on third-party rights.
- We reserve the right to modify these terms to improve clarity or address new regulatory requirements. Significant changes will be communicated in advance.

If you have any questions about these terms, please contact support@aitutor.app.''',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
