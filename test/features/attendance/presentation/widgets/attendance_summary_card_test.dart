import 'package:ai_tutor_web/features/attendance/presentation/widgets/attendance_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AttendanceSummaryCard displays ratios and counts', (tester) async {
    await tester.pumpWidget(
       MaterialApp(
        home: Scaffold(
          body:  AttendanceSummaryCard(
            date: DateTime(2025, 9, 2),
            totalStudents: 50,
            presentCount: 40,
            absentCount: 8,
            lateCount: 2,
          ),
        ),
      ),
    );

    expect(find.text("Today's Summary"), findsOneWidget);
    expect(find.text('40/50'), findsOneWidget);
    expect(find.text('Students present'), findsOneWidget);
    expect(find.text('80% attendance'), findsOneWidget);
    expect(find.text('8'), findsWidgets); // absent count badge
    expect(find.text('2'), findsWidgets); // late count badge
  });
}
