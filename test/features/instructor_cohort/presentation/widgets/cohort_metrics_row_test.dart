import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/instructor_cohort/domain/models/cohort_metric.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/widgets/cohort_metrics_row.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final metrics = [
    CohortMetric(
      label: 'Class Completion',
      value: '72%',
      description: 'Completion rate',
      icon: Icons.check_circle_outline,
      iconBackground: AppColors.quickActionGreen,
    ),
    CohortMetric(
      label: 'Quiz Score',
      value: '81%',
      description: 'Average quiz score',
      icon: Icons.timer_outlined,
      iconBackground: AppColors.quickActionOrange,
    ),
  ];

  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders metric cards', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(CohortMetricsRow(metrics: metrics, isCompact: false)),
    );

    expect(find.text('Class Completion'), findsOneWidget);
    expect(find.text('72%'), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
  });

  testWidgets('wraps cards when compact', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(
        SizedBox(
          width: 320,
          child: CohortMetricsRow(metrics: metrics, isCompact: true),
        ),
      ),
    );

    expect(find.byType(Wrap), findsOneWidget);
    final cardWidths = tester.widgetList<SizedBox>(
      find.byWidgetPredicate(
        (widget) =>
            widget is SizedBox &&
            widget.height != null &&
            widget.height!.toStringAsFixed(0) == '110',
      ),
    );

    expect(cardWidths, isNotEmpty);
    final width = cardWidths.first.width!;
    expect(width, lessThanOrEqualTo(262));
    expect(width, greaterThanOrEqualTo(180));
  });
}
