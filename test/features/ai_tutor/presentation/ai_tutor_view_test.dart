import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AiTutorData data = AiTutorData.standard;

  AiTutorSelections initialSelections() => AiTutorSelections.fromData(data);

  Future<void> pumpView(
    WidgetTester tester, {
    required double width,
    double height = 1000,
    AiTutorSelections? selections,
    ValueChanged<String>? onPersonalityChanged,
    ValueChanged<String>? onVoiceChanged,
  }) async {
    final view = tester.view;
    final Size originalSize = view.physicalSize;
    final double originalPixelRatio = view.devicePixelRatio;

    view
      ..physicalSize = Size(width, height)
      ..devicePixelRatio = 1.0;
    addTearDown(() {
      view
        ..physicalSize = originalSize
        ..devicePixelRatio = originalPixelRatio;
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                width: width,
                child: AiTutorView(
                  data: data,
                  selections: selections ?? initialSelections(),
                  onPersonalityChanged: onPersonalityChanged ?? (_) {},
                  onVoiceChanged: onVoiceChanged ?? (_) {},
                  onResponseSpeedChanged: (_) {},
                  onContentStrictnessChanged: (_) {},
                  onLanguageChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('lays out cards side by side on wide width', (tester) async {
    await pumpView(tester, width: 1200);

    final Size personalitySize =
        tester.getSize(find.byKey(const ValueKey('ai-tutor-card-personality')));
    expect(personalitySize.width, closeTo(558, 1));

    final Size responseSize =
        tester.getSize(find.byKey(const ValueKey('ai-tutor-card-response')));
    expect(responseSize.width, closeTo(558, 1));
  });

  testWidgets('uses single column layout on narrow width', (tester) async {
    await pumpView(tester, width: 700);

    final Size personalitySize =
        tester.getSize(find.byKey(const ValueKey('ai-tutor-card-personality')));
    expect(personalitySize.width, closeTo(560, 0.5));
  });

  testWidgets('invokes personality callback when radio changes', (tester) async {
    String? selected;
    await pumpView(
      tester,
      width: 900,
      onPersonalityChanged: (value) => selected = value,
    );

    await tester.tap(find.byKey(const ValueKey('ai-tutor-personality-formal')));
    await tester.pumpAndSettle();

    expect(selected, 'formal');
  });

  testWidgets('invokes voice callback when dropdown changes', (tester) async {
    String? selectedVoice;
    await pumpView(
      tester,
      width: 900,
      onVoiceChanged: (value) => selectedVoice = value,
    );

    await tester.tap(find.byKey(const ValueKey('ai-tutor-voice-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Male (Calm)').last);
    await tester.pumpAndSettle();

    expect(selectedVoice, 'Male (Calm)');
  });
}
