import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/dashboard_top_bar.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/utils/responsive_breakpoints.dart';
import 'package:flutter/material.dart';

class DashboardShell extends StatelessWidget {
  const DashboardShell({
    super.key,
    required this.activeRoute,
    required this.builder,
    this.scrollable = true,
  });

  final String activeRoute;
  final Widget Function(BuildContext context, DashboardShellData data) builder;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isDesktop = ResponsiveBreakpoints.isDesktop(width);
        final bool isTablet = ResponsiveBreakpoints.isTablet(width);

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: isDesktop
              ? null
              : Drawer(
                  child: SafeArea(
                    child: DashboardSidebar(activeRoute: activeRoute),
                  ),
                ),
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isDesktop) DashboardSidebar(activeRoute: activeRoute),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.dashboardGradientTop,
                          AppColors.dashboardGradientBottom,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Builder(
                      builder: (innerContext) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DashboardTopBar(
                              onMenuPressed: isDesktop
                                  ? null
                                  : () => Scaffold.of(innerContext).openDrawer(),
                            ),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, contentConstraints) {
                                  final double contentWidth = contentConstraints.maxWidth;
                                  final EdgeInsets padding = EdgeInsets.symmetric(
                                    horizontal: isDesktop
                                        ? 40
                                        : isTablet
                                            ? 28
                                            : 20,
                                    vertical: isDesktop ? 32 : 24,
                                  );

                                  final double availableWidth =
                                      (contentWidth - padding.horizontal).clamp(0.0, contentWidth);
                                  final double preferredMaxWidth = isDesktop
                                      ? 1240
                                      : isTablet
                                          ? 960
                                          : availableWidth;
                                  final double resolvedWidth = availableWidth <= 0
                                      ? preferredMaxWidth
                                      : availableWidth.clamp(0.0, preferredMaxWidth);

                                  final data = DashboardShellData(
                                    isDesktop: isDesktop,
                                    isTablet: isTablet,
                                    maxWidth: contentWidth,
                                    contentWidth: resolvedWidth,
                                    padding: padding,
                                  );

                                  Widget content = builder(context, data);

                                  if (scrollable) {
                                    content = SingleChildScrollView(
                                      padding: padding,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: preferredMaxWidth),
                                          child: SizedBox(
                                            width: resolvedWidth,
                                            child: content,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    content = Padding(
                                      padding: padding,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(maxWidth: preferredMaxWidth),
                                          child: SizedBox(
                                            width: resolvedWidth,
                                            child: content,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return content;
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DashboardShellData {
  const DashboardShellData({
    required this.isDesktop,
    required this.isTablet,
    required this.maxWidth,
    required this.contentWidth,
    required this.padding,
  });

  final bool isDesktop;
  final bool isTablet;
  bool get isMobile => !isTablet;
  final double maxWidth;
  final double contentWidth;
  final EdgeInsets padding;
}
