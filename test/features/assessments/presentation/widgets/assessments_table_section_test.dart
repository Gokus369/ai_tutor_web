import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AssessmentRecord recordA = AssessmentRecord(
    title: 'Linear Equations Homework',
    subject: 'Maths',
    dueDateLabel: '05 Sep 2025',
    status: AssessmentStatus.completed,
    submittedBy: '25/30',
  );

  const AssessmentRecord recordB = AssessmentRecord(
    title: 'Thermodynamics Quiz',
    subject: 'Physics',
    dueDateLabel: '06 Sep 2025',
    status: AssessmentStatus.pending,
  );

  const AssessmentSectionData assignmentsSection = AssessmentSectionData(
    view: AssessmentView.assignments,
    records: [recordA, recordB],
    columns: ['Assessment', 'Subject', 'Due Date', 'Status', 'Submitted By'],
  );

  Future<void> pumpTable(
    WidgetTester tester, {
    required bool compact,
    AssessmentSectionData section = assignmentsSection,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: compact ? 420 : 980,
            child: AssessmentsTableSection(
              title: 'Assignments',
              section: section,
              compact: compact,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders wide table with header and rows', (tester) async {
    await pumpTable(tester, compact: false);

    expect(find.byKey(const ValueKey('assessments-table-wide')), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text(recordA.title), findsOneWidget);
    expect(find.text(recordB.title), findsOneWidget);
    expect(find.text('Submitted By'), findsOneWidget);
  });

  testWidgets('renders compact cards with contextual details', (tester) async {
    await pumpTable(tester, compact: true);

    expect(find.byKey(const ValueKey('assessments-table-compact')), findsOneWidget);
    expect(find.byKey(const ValueKey('assessments-compact-records')), findsOneWidget);
    expect(find.byKey(ValueKey('assessments-compact-card-${recordA.title}')), findsOneWidget);
    expect(find.textContaining('Submitted'), findsWidgets);
  });
}
