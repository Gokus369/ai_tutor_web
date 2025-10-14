import 'package:ai_tutor_web/features/progress/data/progress_demo_data.dart';
import 'package:ai_tutor_web/features/progress/presentation/progress_screen.dart';
import 'package:ai_tutor_web/features/progress/presentation/widgets/progress_students_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildScreen() => MaterialApp(home: ProgressScreen(data: ProgressDemoData.build()));

  testWidgets('shows modules view by default', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.text('Mathematics'), findsOneWidget);
    expect(find.text('Linear Equations'), findsOneWidget);
  });

  testWidgets('filters students view based on search query', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Students').last);
    await tester.pumpAndSettle();

    final searchField = find.byType(TextField).last;
    expect(searchField, findsOneWidget);

    await tester.enterText(searchField, 'Rowan');
    await tester.pumpAndSettle();

    expect(find.text('Rowan Hahn'), findsOneWidget);
    expect(find.text('Giovanni Fields'), findsNothing);
  });

  testWidgets('students view displays column dividers', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Students').last);
    await tester.pumpAndSettle();

    final headerDividerCount = tester.widgetList(find.byType(ProgressHeaderDivider)).length;
    final rowDividerCount = tester.widgetList(find.byType(ProgressRowDivider)).length;

    expect(headerDividerCount, equals(2));
    expect(rowDividerCount, greaterThanOrEqualTo(2));
  });
}
