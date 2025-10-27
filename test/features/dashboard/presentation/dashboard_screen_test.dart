import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/dashboard_screen.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _wrap() {
    return MaterialApp(theme: AppTheme.light(), home: const DashboardScreen());
  }

  Future<void> _pumpDashboard(WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1400, 1200);
    tester.binding.window.devicePixelRatioTestValue = 1;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(_wrap());
  }

  testWidgets('tapping Send Announcement opens dialog', (tester) async {
    await _pumpDashboard(tester);

    await tester.tap(
      find.widgetWithText(QuickActionButton, 'Send Announcement'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Send Announcement'), findsWidgets);
  });

  testWidgets('tapping Create Class opens dialog', (tester) async {
    await _pumpDashboard(tester);

    await tester.tap(find.widgetWithText(QuickActionButton, 'Create Class'));
    await tester.pumpAndSettle();

    expect(find.text('New Class'), findsOneWidget);
  });

  testWidgets('tapping Assign Quiz opens dialog', (tester) async {
    await _pumpDashboard(tester);

    await tester.tap(find.widgetWithText(QuickActionButton, 'Assign Quiz'));
    await tester.pumpAndSettle();

    expect(find.text('Assign Quiz'), findsWidgets);
  });
}
