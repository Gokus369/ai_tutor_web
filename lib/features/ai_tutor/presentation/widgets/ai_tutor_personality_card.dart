import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_dropdown_field.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_radio_group.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_section_card.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AiTutorPersonalityCard extends StatelessWidget {
  const AiTutorPersonalityCard({
    super.key,
    required this.data,
    required this.selections,
    required this.onPersonalityChanged,
    required this.onVoiceChanged,
  });

  final AiTutorData data;
  final AiTutorSelections selections;
  final ValueChanged<String> onPersonalityChanged;
  final ValueChanged<String> onVoiceChanged;

  @override
  Widget build(BuildContext context) {
    return AiTutorSectionCard(
      key: const ValueKey('ai-tutor-card-personality'),
      title: 'Tutor Personality & Voice',
      withDividers: true,
      children: [
        AiTutorRadioGroup(
          label: 'Tutor Personality & Voice',
          options: data.personalityOptions,
          groupValue: selections.personality,
          onChanged: onPersonalityChanged,
          optionKeyBuilder: (option) => ValueKey('ai-tutor-personality-${option.value}'),
        ),
        AiTutorDropdownField(
          label: 'Voice Selection',
          value: selections.voice,
          options: data.voiceOptions,
          onChanged: onVoiceChanged,
          dropdownKey: const ValueKey('ai-tutor-voice-dropdown'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            key: const ValueKey('ai-tutor-preview-voice'),
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
    );
  }
}
