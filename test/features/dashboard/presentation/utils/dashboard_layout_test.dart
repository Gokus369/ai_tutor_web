import 'package:ai_tutor_web/features/dashboard/presentation/utils/dashboard_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('summary layout chooses columns correctly', () {
    expect(buildSummaryLayout(1200).columns, 4);
    expect(buildSummaryLayout(800).columns, 2);
    expect(buildSummaryLayout(400).columns, 1);
  });

  test('quick actions layout uses fixed width on wide screens', () {
    final layout = buildQuickActionsLayout(
      availableWidth: 1200,
      actionCount: 4,
      isDesktop: true,
    );
    expect(layout.isFixedWidth, isTrue);
    expect(layout.itemWidth, 254);
  });

  test('quick actions layout falls back to wrap on narrow screens', () {
    final layout = buildQuickActionsLayout(
      availableWidth: 600,
      actionCount: 4,
      isDesktop: false,
    );
    expect(layout.isFixedWidth, isFalse);
    expect(layout.columns, greaterThanOrEqualTo(1));
    expect(layout.wrapWidth, isNotNull);
  });
}

