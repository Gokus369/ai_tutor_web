import 'package:ai_tutor_web/app/router/app_routes.dart';
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
  final List<String> _personalities = const ['Friendly Coach', 'Professional Mentor', 'Supportive Guide'];
  final List<String> _tones = const ['Calm', 'Energetic', 'Encouraging', 'Analytical'];
  final List<String> _voices = const ['Aria', 'Nova', 'Aiden', 'Harper'];
  final List<String> _responseSpeeds = const ['Fast', 'Balanced', 'Deliberate'];
  final List<String> _contentRichness = const ['Concise', 'Balanced', 'Detailed'];
  final List<String> _languages = const ['English', 'Spanish', 'French', 'Hindi'];
  final List<String> _responseLengths = const ['Short', 'Medium', 'Long Form'];

  String _selectedPersonality = 'Friendly Coach';
  String _selectedTone = 'Encouraging';
  String _selectedVoice = 'Aria';
  bool _previewVoice = true;

  String _selectedResponseSpeed = 'Balanced';
  String _selectedContentRichness = 'Detailed';
  String _selectedLanguage = 'English';
  String _selectedResponseLength = 'Medium';

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.aiTutor,
      builder: (context, shell) {
        final bool isCompact = shell.contentWidth < 1180;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Tutor', style: AppTypography.dashboardTitle),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE1EEF3), Color(0xFFF6FBFD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.sidebarBorder),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 22,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Tutor',
                    style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 28),
                  Wrap(
                    spacing: 28,
                    runSpacing: 28,
                    children: [
                      SizedBox(
                        width: isCompact ? double.infinity : 558,
                        child: _FormSectionCard(
                          title: 'Tutor Personality & Voice',
                          children: [
                            _DropdownField(
                              label: 'Tutor Personality & Voice',
                              value: _selectedPersonality,
                              options: _personalities,
                              onChanged: (value) => setState(() => _selectedPersonality = value),
                            ),
                            _DropdownField(
                              label: 'Tone & Energy',
                              value: _selectedTone,
                              options: _tones,
                              onChanged: (value) => setState(() => _selectedTone = value),
                            ),
                            _DropdownField(
                              label: 'Voice Selection',
                              value: _selectedVoice,
                              options: _voices,
                              onChanged: (value) => setState(() => _selectedVoice = value),
                            ),
                            _CheckboxField(
                              label: 'Preview Voice',
                              value: _previewVoice,
                              onChanged: (value) => setState(() => _previewVoice = value),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: isCompact ? double.infinity : 558,
                        child: _FormSectionCard(
                          title: 'AI Response Controls',
                          children: [
                            _DropdownField(
                              label: 'Response Speed',
                              value: _selectedResponseSpeed,
                              options: _responseSpeeds,
                              onChanged: (value) => setState(() => _selectedResponseSpeed = value),
                            ),
                            _DropdownField(
                              label: 'Content Richness',
                              value: _selectedContentRichness,
                              options: _contentRichness,
                              onChanged: (value) => setState(() => _selectedContentRichness = value),
                            ),
                            _DropdownField(
                              label: 'Language of Interaction',
                              value: _selectedLanguage,
                              options: _languages,
                              onChanged: (value) => setState(() => _selectedLanguage = value),
                            ),
                            _DropdownField(
                              label: 'Response Length',
                              value: _selectedResponseLength,
                              options: _responseLengths,
                              onChanged: (value) => setState(() => _selectedResponseLength = value),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 176,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        textStyle: AppTypography.button.copyWith(fontSize: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

class _FormSectionCard extends StatelessWidget {
  const _FormSectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.sidebarBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 24),
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        InputDecorator(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.sidebarBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.sidebarBorder),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.expand_more_rounded, color: AppColors.iconMuted),
              onChanged: (selected) {
                if (selected == null) return;
                onChanged(selected);
              },
              items: options
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckboxField extends StatelessWidget {
  const _CheckboxField({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: (checked) => onChanged(checked ?? false),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
