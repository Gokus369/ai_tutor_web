import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_dropdown_field.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_section_card.dart';
import 'package:flutter/material.dart';

class AiTutorResponseControlsCard extends StatelessWidget {
  const AiTutorResponseControlsCard({
    super.key,
    required this.data,
    required this.selections,
    required this.onResponseSpeedChanged,
    required this.onContentStrictnessChanged,
    required this.onLanguageChanged,
  });

  final AiTutorData data;
  final AiTutorSelections selections;
  final ValueChanged<String> onResponseSpeedChanged;
  final ValueChanged<String> onContentStrictnessChanged;
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return AiTutorSectionCard(
      key: const ValueKey('ai-tutor-card-response'),
      title: 'AI Response Controls',
      withDividers: true,
      children: [
        AiTutorDropdownField(
          label: 'Response Speed',
          value: selections.responseSpeed,
          options: data.responseSpeedOptions,
          onChanged: onResponseSpeedChanged,
          dropdownKey: const ValueKey('ai-tutor-response-speed'),
        ),
        AiTutorDropdownField(
          label: 'Content Strictness',
          value: selections.contentStrictness,
          options: data.contentStrictnessOptions,
          onChanged: onContentStrictnessChanged,
          dropdownKey: const ValueKey('ai-tutor-content-strictness'),
        ),
        AiTutorDropdownField(
          label: 'Language Preference',
          value: selections.language,
          options: data.languageOptions,
          onChanged: onLanguageChanged,
          dropdownKey: const ValueKey('ai-tutor-language'),
        ),
      ],
    );
  }
}
