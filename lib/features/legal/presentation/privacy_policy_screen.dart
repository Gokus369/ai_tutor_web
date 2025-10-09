import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              'Privacy Policy',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: 16),
            const Text(
              '''
We value your privacy and strive to be transparent about how we collect, use, and safeguard your information.

- We collect only the data needed to deliver and improve AiTutor services.
- Personal information such as your name, email, selected role, and school preferences is used to tailor the experience.
- We never sell your data to third parties. Service providers assisting us are bound by strict confidentiality agreements.
- You can request data export or deletion at any time by emailing privacy@aitutor.app.

For the full policy or specific questions, contact privacy@aitutor.app.''',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
