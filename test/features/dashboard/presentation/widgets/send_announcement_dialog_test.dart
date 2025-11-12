import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/send_announcement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  const recipients = ['All Students', 'Class 10'];

  testWidgets('validates required fields before sending', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog<SendAnnouncementRequest>(
              context: context,
              builder: (_) =>
                  const SendAnnouncementDialog(recipientOptions: recipients),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Message is required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Parent Meeting');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Please join at 5PM tomorrow.',
    );

    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();

    // dialog should close after successful validation
    expect(find.text('Send Announcement'), findsNothing);
  });
}
