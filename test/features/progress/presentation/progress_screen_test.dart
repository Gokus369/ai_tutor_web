import 'package:ai_tutor_web/features/progress/data/progress_demo_data.dart';
import 'package:ai_tutor_web/features/progress/presentation/progress_screen.dart';
import 'package:ai_tutor_web/shared/widgets/app_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildScreen() =>
      MaterialApp(home: ProgressScreen(data: ProgressDemoData.build()));

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

  testWidgets('students view displays shared data table', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Students').last);
    await tester.pumpAndSettle();

    expect(find.byType(AppDataTable), findsOneWidget);
  });
}
