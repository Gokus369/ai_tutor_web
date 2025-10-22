import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/instructor_cohort/presentation/widgets/instructor_cohort_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final TextEditingController controller = TextEditingController();
  const classOptions = ['All Class', 'Class 10'];
  const topicOptions = ['All Topics', 'Science'];

  Widget _wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders stacked layout when compact', (tester) async {
    await tester.pumpWidget(
      _wrap(
        InstructorCohortHeader(
          title: 'Instructor Cohort',
          searchController: controller,
          classOptions: classOptions,
          topicOptions: topicOptions,
          selectedClass: classOptions.first,
          selectedTopic: topicOptions.first,
          onClassChanged: (_) {},
          onTopicChanged: (_) {},
          onDownloadReport: () {},
          isCompact: true,
        ),
      ),
    );

    expect(find.text('Download Report'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('All Class'), findsOneWidget);
    expect(find.byType(Column), findsWidgets);
  });

  testWidgets('renders horizontal layout when space available', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SizedBox(
          width: 1200,
          child: InstructorCohortHeader(
            title: 'Instructor Cohort',
            searchController: controller,
            classOptions: classOptions,
            topicOptions: topicOptions,
            selectedClass: classOptions.first,
            selectedTopic: topicOptions.first,
            onClassChanged: (_) {},
            onTopicChanged: (_) {},
            onDownloadReport: () {},
            isCompact: false,
          ),
        ),
      ),
    );

    expect(find.byType(Row), findsWidgets);
    expect(find.text('Download Report'), findsOneWidget);
  });
}
