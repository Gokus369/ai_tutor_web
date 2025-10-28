import 'package:ai_tutor_web/features/settings/data/settings_demo_data.dart';
import 'package:ai_tutor_web/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = SettingsDemoData.build();

  Future<void> pumpSettingsView(
    WidgetTester tester, {
    required bool notificationsEnabled,
    ValueChanged<bool>? onToggle,
  }) async {
    final view = tester.view;
    final Size originalSize = view.physicalSize;
    final double originalPixelRatio = view.devicePixelRatio;

    view.physicalSize = const Size(1400, 1000);
    view.devicePixelRatio = 1.0;

    addTearDown(() {
      view.physicalSize = originalSize;
      view.devicePixelRatio = originalPixelRatio;
    });
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsView(
            data: data,
            notificationsEnabled: notificationsEnabled,
            onToggleNotifications: onToggle ?? (_) {},
            onEditProfile: () {},
            onNavigate: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders profile information and sections', (tester) async {
    await pumpSettingsView(tester, notificationsEnabled: true);

    expect(find.text(data.profile.name), findsOneWidget);
    for (final section in data.sections) {
      expect(find.text(section.title), findsOneWidget);
      for (final item in section.items) {
        expect(find.text(item.label), findsWidgets);
      }
    }
  });

  testWidgets('toggle reflects notification state', (tester) async {
    await pumpSettingsView(tester, notificationsEnabled: true);

    final toggleFinder = find.byType(Switch);
    expect(toggleFinder, findsOneWidget);
    final Switch toggle = tester.widget(toggleFinder);
    expect(toggle.value, isTrue);
  });

  testWidgets('toggle callback invoked when switched', (tester) async {
    bool? received;
    await pumpSettingsView(
      tester,
      notificationsEnabled: true,
      onToggle: (value) => received = value,
    );

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(received, isNotNull);
  });
}
