import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/add_lesson_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const subjects = ['Mathematics', 'Science'];
  const classes = ['Class 10', 'Class 9'];

  Widget _wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('requires lesson title', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1400, 1000);
    tester.binding.window.devicePixelRatioTestValue = 1;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    AddLessonRequest? result;

    await tester.pumpWidget(
      _wrap(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<AddLessonRequest>(
                context: context,
                builder: (_) => const AddLessonDialog(
                  subjectOptions: subjects,
                  classOptions: classes,
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('Lesson title is required'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter your Topic'),
      'Algebra Basics',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Enter your Lesson Title'),
      'Lesson 1',
    );

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
  });
}
