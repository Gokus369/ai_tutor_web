import 'package:ai_tutor_web/features/reports/data/reports_demo_data.dart';
import 'package:ai_tutor_web/features/reports/presentation/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final demoData = ReportsDemoData.build();

  Future<void> pumpReportsView(
    WidgetTester tester, {
    required double width,
    String? selectedClass,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: SizedBox(
            width: width,
            child: ReportsView(
              data: demoData,
              selectedClass: selectedClass ?? demoData.initialClass,
              onClassChanged: (_) {},
              onExportPressed: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('renders metrics row horizontally on wide layout', (tester) async {
    await pumpReportsView(tester, width: 1200);

    final metricSize = tester.getSize(find.byKey(const ValueKey('reports-metric-0')));
    expect(metricSize.width, closeTo(340, 0.5));
  });

  testWidgets('stacks metric cards vertically on narrow layout', (tester) async {
    await pumpReportsView(tester, width: 720);

    final metricSize = tester.getSize(find.byKey(const ValueKey('reports-metric-0')));
    expect(metricSize.width, closeTo(720, 0.5));
  });

  testWidgets('shows all subject progress tiles', (tester) async {
    await pumpReportsView(tester, width: 900);

    for (final subject in demoData.subjects) {
      expect(find.byKey(ValueKey('reports-subject-${subject.subject}')), findsOneWidget);
    }
  });
}
