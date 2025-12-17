import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/class_details_screen.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_card.dart';
import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Class details screen shows summaries and tabs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ClassDetailsScreen()),
    );

    expect(find.text('Class 12'), findsOneWidget);
    expect(find.text('Total Students'), findsOneWidget);
    expect(find.text('Students'), findsWidgets);
  });

  testWidgets('Class card navigates to class details on tap', (tester) async {
    final info = const ClassInfo(
      id: 1,
      name: 'Class 11',
      board: 'CBSE',
      boardId: 1,
      schoolId: 101,
      studentCount: 30,
      subjectSummary: 'Mathematics, English',
      syllabusProgress: 0.6,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: ClassCard(
              info: info,
              onViewDetails: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ClassDetailsScreen(initialInfo: info),
                  settings: const RouteSettings(name: AppRoutes.classDetails),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    expect(find.text('Class 11'), findsOneWidget);
  });
}
