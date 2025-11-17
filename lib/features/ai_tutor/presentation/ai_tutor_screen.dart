import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_inputs.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_section_card.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_styles.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AiTutorScreen extends StatefulWidget {
  const AiTutorScreen({super.key, this.data = AiTutorData.standard});

  final AiTutorData data;

  @override
  State<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends State<AiTutorScreen> {
  late AiTutorSelections _selections;

  @override
  void initState() {
    super.initState();
    _selections = AiTutorSelections.fromData(widget.data);
  }

  @override
  void didUpdateWidget(covariant AiTutorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _selections = AiTutorSelections.fromData(widget.data);
    }
  }

  void _setPersonality(String value) {
    setState(() {
      _selections = _selections.copyWith(personality: value);
    });
  }

  void _setVoice(String value) {
    setState(() {
      _selections = _selections.copyWith(voice: value);
    });
  }

  void _setResponseSpeed(String value) {
    setState(() {
      _selections = _selections.copyWith(responseSpeed: value);
    });
  }

  void _setContentStrictness(String value) {
    setState(() {
      _selections = _selections.copyWith(contentStrictness: value);
    });
  }

  void _setLanguage(String value) {
    setState(() {
      _selections = _selections.copyWith(language: value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.aiTutor,
      title: 'AI Tutor',
      alignContentToStart: true,
      maxContentWidth: 1200,
      builder: (context, shell) {
        return AiTutorView(
          data: widget.data,
          selections: _selections,
          onPersonalityChanged: _setPersonality,
          onVoiceChanged: _setVoice,
          onResponseSpeedChanged: _setResponseSpeed,
          onContentStrictnessChanged: _setContentStrictness,
          onLanguageChanged: _setLanguage,
          showTitle: false,
        );
      },
    );
  }
}

@visibleForTesting
class AiTutorView extends StatelessWidget {
  const AiTutorView({
    super.key,
    required this.data,
    required this.selections,
    required this.onPersonalityChanged,
    required this.onVoiceChanged,
    required this.onResponseSpeedChanged,
    required this.onContentStrictnessChanged,
    required this.onLanguageChanged,
    this.showTitle = true,
  });

  final AiTutorData data;
  final AiTutorSelections selections;
  final ValueChanged<String> onPersonalityChanged;
  final ValueChanged<String> onVoiceChanged;
  final ValueChanged<String> onResponseSpeedChanged;
  final ValueChanged<String> onContentStrictnessChanged;
  final ValueChanged<String> onLanguageChanged;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double resolvedWidth = constraints.maxWidth >= 1200 ? 1200 : constraints.maxWidth;
        final bool singleColumn = resolvedWidth < 912;
        final double horizontalGap = 24;
        final double panelPadding = singleColumn ? 24 : 30;
        final double availableWidth = resolvedWidth - (panelPadding * 2);

        const double minCardWidth = 360;
        const double maxCardWidth = 560;
        double cardWidth = singleColumn ? availableWidth : (availableWidth - horizontalGap) / 2;
        cardWidth = cardWidth.clamp(minCardWidth, maxCardWidth).toDouble();

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: resolvedWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showTitle) ...[
                  Text('AI Tutor', style: AppTypography.dashboardTitle),
                  const SizedBox(height: 24),
                ],
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
                      singleColumn
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: cardWidth,
                                  child: _buildPersonalityCard(
                                    data: data,
                                    selections: selections,
                                    onPersonalityChanged: onPersonalityChanged,
                                    onVoiceChanged: onVoiceChanged,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: cardWidth,
                                  child: _buildResponseControlsCard(
                                    data: data,
                                    selections: selections,
                                    onResponseSpeedChanged: onResponseSpeedChanged,
                                    onContentStrictnessChanged: onContentStrictnessChanged,
                                    onLanguageChanged: onLanguageChanged,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: minCardWidth,
                                      maxWidth: maxCardWidth,
                                    ),
                                    child: _buildPersonalityCard(
                                      data: data,
                                      selections: selections,
                                      onPersonalityChanged: onPersonalityChanged,
                                      onVoiceChanged: onVoiceChanged,
                                    ),
                                  ),
                                ),
                                SizedBox(width: horizontalGap),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: minCardWidth,
                                      maxWidth: maxCardWidth,
                                    ),
                                    child: _buildResponseControlsCard(
                                      data: data,
                                      selections: selections,
                                      onResponseSpeedChanged: onResponseSpeedChanged,
                                      onContentStrictnessChanged: onContentStrictnessChanged,
                                      onLanguageChanged: onLanguageChanged,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: singleColumn ? cardWidth : null,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: singleColumn ? double.infinity : 176,
                              height: 50,
                              child: FilledButton(
                                key: const ValueKey('ai-tutor-update-button'),
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                  textStyle: AppTypography.button.copyWith(fontSize: 15),
                                ),
                                child: const Text('Update'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget _buildPersonalityCard({
  required AiTutorData data,
  required AiTutorSelections selections,
  required ValueChanged<String> onPersonalityChanged,
  required ValueChanged<String> onVoiceChanged,
}) {
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

Widget _buildResponseControlsCard({
  required AiTutorData data,
  required AiTutorSelections selections,
  required ValueChanged<String> onResponseSpeedChanged,
  required ValueChanged<String> onContentStrictnessChanged,
  required ValueChanged<String> onLanguageChanged,
}) {
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
