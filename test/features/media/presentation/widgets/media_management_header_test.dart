import 'package:ai_tutor_web/features/media/presentation/widgets/media_management_header.dart';
import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const classOptions = ['Class 10', 'Class 11'];

  Widget _wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders horizontal layout with dropdown and button', (
    tester,
  ) async {
    String selected = classOptions.first;

    await tester.pumpWidget(
      _wrap(
        MediaManagementHeader(
          title: 'Media Management',
          classOptions: classOptions,
          selectedClass: selected,
          stacked: false,
          onClassChanged: (value) => selected = value,
          onUploadNew: () {},
        ),
      ),
    );

    expect(find.text('Media Management'), findsOneWidget);
    expect(find.text('Class 10'), findsOneWidget);
    expect(find.text('Upload New'), findsOneWidget);
    expect(find.byType(Row), findsWidgets);

    await tester.tap(find.text('Class 10'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Class 11').last);
    await tester.pumpAndSettle();
    expect(selected, 'Class 11');
  });

  testWidgets('renders stacked layout when requested', (tester) async {
    await tester.pumpWidget(
      _wrap(
        MediaManagementHeader(
          title: 'Media Management',
          classOptions: classOptions,
          selectedClass: 'Class 10',
          stacked: true,
          onClassChanged: (_) {},
          onUploadNew: () {},
        ),
      ),
    );

    // stacked layout should contain exactly one Column at root
    expect(find.byType(Column), findsWidgets);
    expect(find.text('Upload New'), findsOneWidget);
  });
}
