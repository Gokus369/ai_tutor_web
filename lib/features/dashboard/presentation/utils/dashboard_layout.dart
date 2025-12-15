class SummaryLayoutConfig {
  const SummaryLayoutConfig({
    required this.columns,
    required this.itemWidth,
    required this.spacing,
  });

  final int columns;
  final double itemWidth;
  final double spacing;
}

class QuickActionsLayoutConfig {
  const QuickActionsLayoutConfig.fixed({
    required this.itemWidth,
    required this.spacing,
  })  : isFixedWidth = true,
        wrapWidth = null,
        columns = 4;

  const QuickActionsLayoutConfig.wrap({
    required this.wrapWidth,
    required this.spacing,
    required this.columns,
  })  : isFixedWidth = false,
        itemWidth = null;

  final bool isFixedWidth;
  final double? itemWidth;
  final double? wrapWidth;
  final int columns;
  final double? spacing;
}

SummaryLayoutConfig buildSummaryLayout(double availableWidth) {
  const double spacing = 20;
  final int columns;
  if (availableWidth >= 960) {
    columns = 4;
  } else if (availableWidth >= 640) {
    columns = 2;
  } else {
    columns = 1;
  }
  final double itemWidth = columns == 1
      ? double.infinity
      : (availableWidth - spacing * (columns - 1)) / columns;

  return SummaryLayoutConfig(columns: columns, itemWidth: itemWidth, spacing: spacing);
}

QuickActionsLayoutConfig buildQuickActionsLayout({
  required double availableWidth,
  required int actionCount,
  required bool isDesktop,
  double desiredWidth = 254,
  double spacing = 16,
}) {
  final double innerWidth = (availableWidth - 48).clamp(0.0, availableWidth);
  const double minItemWidth = 180;
  final double availableForItems =
      innerWidth - spacing * (actionCount - 1);
  final double singleRowWidth = availableForItems / actionCount;

  // Prefer a single row by shrinking buttons evenly if there's room above the minimum.
  if (singleRowWidth >= minItemWidth) {
    return QuickActionsLayoutConfig.fixed(
      itemWidth: singleRowWidth,
      spacing: spacing,
    );
  }

  late final int columns;
  if (availableWidth >= 960) {
    columns = 4;
  } else if (availableWidth >= 720) {
    columns = 3;
  } else if (availableWidth >= 520) {
    columns = 2;
  } else {
    columns = 1;
  }

  final double itemWidth =
      columns == 1 ? innerWidth : (innerWidth - spacing * (columns - 1)) / columns;

  return QuickActionsLayoutConfig.wrap(
    wrapWidth: itemWidth,
    spacing: spacing,
    columns: columns,
  );
}
