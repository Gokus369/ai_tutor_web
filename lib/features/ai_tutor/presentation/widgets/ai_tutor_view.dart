import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_personality_card.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_response_controls_card.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

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
                                  child: AiTutorPersonalityCard(
                                    data: data,
                                    selections: selections,
                                    onPersonalityChanged: onPersonalityChanged,
                                    onVoiceChanged: onVoiceChanged,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: cardWidth,
                                  child: AiTutorResponseControlsCard(
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
                                    child: AiTutorPersonalityCard(
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
                                    child: AiTutorResponseControlsCard(
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
