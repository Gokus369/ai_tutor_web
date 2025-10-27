import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/assign_quiz_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const subjects = ['Select Subject', 'Mathematics'];
  const topics = ['Select Topic', 'Algebra'];
  const assignTo = ['Select', 'Entire Class'];
  const classes = ['Select', 'Class 10'];

  Widget _wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('requires title before submission', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1500, 1200);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<AssignQuizRequest>(
              context: context,
              builder: (_) => const AssignQuizDialog(
                subjectOptions: subjects,
                topicOptions: topics,
                assignToOptions: assignTo,
                classOptions: classes,
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Assign'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Quiz 1');
    await tester.tap(find.text('Assign'));
    await tester.pumpAndSettle();

    expect(find.text('Assign Quiz'), findsNothing);
  });
}
