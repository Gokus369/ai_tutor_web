import 'package:ai_tutor_web/features/progress/data/progress_demo_data.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_modules_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = ProgressDemoData.build();
  final initialClassData = data.initialClassData;

  Widget wrapWithApp(Widget child) => MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      );

  testWidgets('renders mathematics details and additional subjects', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(
        ProgressModulesView(
          detail: initialClassData.mathematics,
          additionalSubjects: initialClassData.additionalSubjects,
          compact: false,
        ),
      ),
    );

    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Linear Equations'), findsOneWidget);
    expect(find.text('Chapter 1: Linear Equations (10/15 Topics)'), findsOneWidget);
    for (final summary in initialClassData.additionalSubjects) {
      expect(find.text(summary.name), findsWidgets);
    }
  });
}
