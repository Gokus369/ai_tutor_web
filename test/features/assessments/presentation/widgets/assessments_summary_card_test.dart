import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';
import 'package:ai_tutor_web/features/assessments/presentation/widgets/assessments_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const AssessmentFilterOptions filters = AssessmentFilterOptions(
    classOptions: ['Class 10', 'Class 9'],
    statusOptions: ['All Status', 'Completed', 'Pending'],
    subjectOptions: ['All Subjects', 'Maths', 'Science'],
    initialClass: 'Class 10',
    initialStatus: 'All Status',
    initialSubject: 'All Subjects',
  );

  Future<void> pumpSummary(
    WidgetTester tester, {
    required double width,
    AssessmentView activeView = AssessmentView.assignments,
    ValueChanged<AssessmentView>? onViewChanged,
  }) async {
    final TextEditingController searchController = TextEditingController();
    addTearDown(searchController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: width,
            child: AssessmentsSummaryCard(
              filters: filters,
              activeView: activeView,
              onViewChanged: onViewChanged ?? (_) {},
              onClassChanged: (_) {},
              onStatusChanged: (_) {},
              onSubjectChanged: (_) {},
              searchController: searchController,
              onSearchChanged: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('uses expanded header layout on wide screens', (tester) async {
    await pumpSummary(tester, width: 980);

    expect(
      find.byKey(const ValueKey('assessments-summary-header-expanded-layout')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('assessments-summary-header-collapsed-layout')),
      findsNothing,
    );
  });

  testWidgets('collapses header and stacks filters on narrow screens', (tester) async {
    await pumpSummary(tester, width: 640);

    expect(
      find.byKey(const ValueKey('assessments-summary-header-collapsed-layout')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('assessments-summary-filters-stacked-layout')),
      findsOneWidget,
    );
  });

  testWidgets('calls onViewChanged when tapping view chips', (tester) async {
    AssessmentView? received;

    await pumpSummary(
      tester,
      width: 980,
      onViewChanged: (view) => received = view,
    );

    await tester.tap(find.byKey(const ValueKey('assessments-view-quizzes')));
    await tester.pump();

    expect(received, AssessmentView.quizzes);
  });
}
