import 'dart:math' as math;

import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

typedef DashboardPageBuilder = Widget Function(
  BuildContext context,
  DashboardShellData shell,
);

typedef DashboardPageHeaderBuilder = Widget Function(
  BuildContext context,
  DashboardShellData shell,
);

/// Lightweight wrapper that adds a common title/header layer on top of
/// [DashboardShell] so feature screens can focus on their own content.
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.activeRoute,
    required this.title,
    required this.builder,
    this.titleSpacing = 24,
    this.alignContentToStart = false,
    this.maxContentWidth,
    this.scrollable = true,
    this.header,
    this.headerBuilder,
  });

  final String activeRoute;
  final String title;
  final DashboardPageBuilder builder;
  final double titleSpacing;
  final bool alignContentToStart;
  final double? maxContentWidth;
  final bool scrollable;
  final Widget? header;
  final DashboardPageHeaderBuilder? headerBuilder;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: activeRoute,
      scrollable: scrollable,
      builder: (context, shell) {
        final double effectiveWidth = math.min(
          shell.contentWidth,
          maxContentWidth ?? double.infinity,
        );

        Widget headerWidget;
        if (headerBuilder != null) {
          headerWidget = headerBuilder!(context, shell);
        } else {
          headerWidget = header ??
              Text(
                title,
                style: AppTypography.dashboardTitle,
              );
        }

        Widget content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget,
            SizedBox(height: titleSpacing),
            builder(context, shell),
          ],
        );

        if (alignContentToStart || maxContentWidth != null) {
          final Alignment alignment =
              alignContentToStart ? Alignment.topLeft : Alignment.topCenter;
          content = Align(
            alignment: alignment,
            child: SizedBox(
              width: effectiveWidth,
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }
}
