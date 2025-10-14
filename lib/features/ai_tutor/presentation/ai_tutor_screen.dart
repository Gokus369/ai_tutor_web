import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_inputs.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_section_card.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_styles.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key});

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  final List<AiTutorRadioOption> _personalityOptions = const [
    AiTutorRadioOption(
      value: 'friendly',
      label: 'Friendly & Supportive',
      subtitle: 'Gentle motivation with positive reinforcement.',
    ),
    AiTutorRadioOption(
      value: 'formal',
      label: 'Formal & Academic',
      subtitle: 'Structured explanations and exam-focused tone.',
    ),
    AiTutorRadioOption(
      value: 'motivational',
      label: 'Motivational & Energetic',
      subtitle: 'High-energy delivery to keep learners engaged.',
    ),
  ];

  final List<String> _voiceOptions = const ['Female (Warm)', 'Male (Calm)', 'Neutral (Balanced)'];
  final List<String> _responseSpeedOptions = const ['Balanced', 'Faster', 'Deliberate'];
  final List<String> _contentStrictnessOptions = const ['Board Specific (State)', 'NCERT Focused', 'Flexible Guidance'];
  final List<String> _languageOptions = const ['English', 'Hindi', 'Spanish', 'French'];
  final List<String> _responseLengthOptions = const ['Concise', 'Balanced', 'Detailed'];

  String _selectedPersonality = 'friendly';
  String _selectedVoice = 'Female (Warm)';
  String _selectedResponseSpeed = 'Balanced';
  String _selectedContentStrictness = 'Board Specific (State)';
  String _selectedLanguage = 'English';
  String _selectedResponseLength = 'Balanced';

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.aiTutor,
      builder: (context, shell) {
        final bool compact = shell.contentWidth < 1200;
        final double panelPadding = compact ? 24 : 32;
        final double cardWidth = compact ? double.infinity : 558;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Tutor', style: AppTypography.dashboardTitle),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: panelPadding, vertical: panelPadding),
              decoration: AiTutorStyles.panelDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Tutor',
                    style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: AiTutorSectionCard(
                          title: 'Tutor Personality & Voice',
                          children: [
                            AiTutorRadioGroup(
                              label: 'Tutor Personality & Voice',
                              options: _personalityOptions,
                              groupValue: _selectedPersonality,
                              onChanged: (value) => setState(() => _selectedPersonality = value),
                            ),
                            AiTutorDropdownField(
                              label: 'Voice Selection',
                              value: _selectedVoice,
                              options: _voiceOptions,
                              onChanged: (value) => setState(() => _selectedVoice = value),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                  foregroundColor: AppColors.primary,
                                  textStyle: AppTypography.button.copyWith(fontSize: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                                label: const Text('Preview Voice'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: AiTutorSectionCard(
                          title: 'AI Response Controls',
                          children: [
                            AiTutorDropdownField(
                              label: 'Response Speed',
                              value: _selectedResponseSpeed,
                              options: _responseSpeedOptions,
                              onChanged: (value) => setState(() => _selectedResponseSpeed = value),
                            ),
                            AiTutorDropdownField(
                              label: 'Content Strictness',
                              value: _selectedContentStrictness,
                              options: _contentStrictnessOptions,
                              onChanged: (value) => setState(() => _selectedContentStrictness = value),
                            ),
                            AiTutorDropdownField(
                              label: 'Language Preference',
                              value: _selectedLanguage,
                              options: _languageOptions,
                              onChanged: (value) => setState(() => _selectedLanguage = value),
                            ),
                            AiTutorDropdownField(
                              label: 'Response Length',
                              value: _selectedResponseLength,
                              options: _responseLengthOptions,
                              onChanged: (value) => setState(() => _selectedResponseLength = value),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 176,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        textStyle: AppTypography.button.copyWith(fontSize: 15),
                      ),
                      child: const Text('Update'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
