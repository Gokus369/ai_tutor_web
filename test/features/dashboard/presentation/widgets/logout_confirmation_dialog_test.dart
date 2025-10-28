import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/confirmation_dialog.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('returns true when logout confirmed', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1000, 800);
    tester.binding.window.devicePixelRatioTestValue = 1;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    bool? result;

    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (_) => const ConfirmationDialog(
                  title: 'Logout',
                  message: 'Are you sure want to logout this account?',
                  confirmLabel: 'Logout',
                  confirmColor: AppColors.accentPink,
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

    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('returns false when cancel tapped', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1000, 800);
    tester.binding.window.devicePixelRatioTestValue = 1;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    bool? result;

    await tester.pumpWidget(
      wrapWithApp(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (_) => const ConfirmationDialog(
                  title: 'Delete Account',
                  message: 'Are you sure want to delete this account?',
                  confirmLabel: 'Delete',
                  confirmColor: AppColors.accentPink,
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

    await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}
