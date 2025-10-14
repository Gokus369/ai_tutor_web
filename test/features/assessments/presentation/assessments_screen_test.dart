import 'package:ai_tutor_web/features/assessments/data/assessment_demo_data.dart';
import 'package:ai_tutor_web/features/assessments/presentation/assessments_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp() => MaterialApp(home: AssessmentsScreen(data: AssessmentDemoData.build()));

  testWidgets('shows assignments view by default', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('assessments-view-assignments')), findsOneWidget);
    expect(find.text('Linear Equations Homework'), findsOneWidget);
  });

  testWidgets('switches to quizzes view', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final quizzesChip = find.byKey(const ValueKey('assessments-view-quizzes'));
    await tester.tap(quizzesChip);
    await tester.pumpAndSettle();

    expect(quizzesChip, findsOneWidget);
    expect(find.text('Science Chapter 5 Quiz'), findsOneWidget);
    expect(find.text('Submitted By'), findsNothing);
  });

  testWidgets('filters assignments by search and status', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    final searchField = find.byKey(const ValueKey('assessments-search'));
    await tester.enterText(searchField, 'Linear');
    await tester.pumpAndSettle();

    expect(find.text('Linear Equations Homework'), findsOneWidget);
    expect(find.text('English Essay - Environment'), findsNothing);

    final statusDropdown = find.byType(DropdownButtonFormField<String>).at(1);
    await tester.tap(statusDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Completed').last);
    await tester.pumpAndSettle();

    expect(find.text('Linear Equations Homework'), findsOneWidget);
    await tester.enterText(searchField, 'Thermo');
    await tester.pumpAndSettle();
    expect(find.text('Thermodynamics'), findsNothing);
  });
}
