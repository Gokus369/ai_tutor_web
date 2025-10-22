import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/instructor_cohort/domain/models/learner_progress.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/widgets/class_completion_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final learners = [
    LearnerProgress(name: 'Priya Sharma', completionPercent: 94),
    LearnerProgress(name: 'Arjun Patel', completionPercent: 88),
  ];

  Widget _wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders learner progress rows', (tester) async {
    await tester.pumpWidget(_wrap(ClassCompletionCard(learners: learners)));

    expect(find.text('Class Completion Progress'), findsOneWidget);
    expect(find.text('Priya Sharma'), findsOneWidget);
    expect(find.text('94%'), findsOneWidget);
  });

  testWidgets('respects compact mode width', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 320,
          child: ClassCompletionCard(learners: learners, isCompact: true),
        ),
      ),
    );

    final card = tester.widget<Container>(find.byType(Container).first);
    expect(card.constraints, isNull);
    expect(find.text('Arjun Patel'), findsOneWidget);
  });
}
