import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/create_class_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('validates required class name', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1400, 1000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () => showDialog<CreateClassRequest>(
                context: context,
                builder: (_) => const CreateClassDialog(
                  boardOptions: ['CBSE', 'ICSE'],
                ),
              ),
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Class name is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Class 10');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();

    expect(find.text('Class name is required'), findsNothing);
  });
}
