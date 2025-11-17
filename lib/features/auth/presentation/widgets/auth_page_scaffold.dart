import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AuthPageScaffold extends StatelessWidget {
  const AuthPageScaffold({
    super.key,
    required this.child,
    this.desiredWidth = 520,
    this.cardPadding = const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 40,
    ),
    this.tallScreenBreakpoint = 760,
    this.topPaddingLarge = 120,
    this.topPaddingSmall = 64,
    this.bottomPaddingLarge = 72,
    this.bottomPaddingSmall = 40,
  });

  final Widget child;
  final double desiredWidth;
  final EdgeInsets cardPadding;
  final double tallScreenBreakpoint;
  final double topPaddingLarge;
  final double topPaddingSmall;
  final double bottomPaddingLarge;
  final double bottomPaddingSmall;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth;
          final double horizontalPadding = maxWidth > desiredWidth
              ? (maxWidth - desiredWidth) / 2
              : 16;
          final double clampedSidePadding = (horizontalPadding * 2)
              .clamp(0.0, maxWidth)
              .toDouble();
          final double availableWidth = maxWidth - clampedSidePadding;
          final double cardWidth = availableWidth > 0
              ? availableWidth.clamp(0.0, desiredWidth).toDouble()
              : desiredWidth;

          final Size screenSize = MediaQuery.of(context).size;
          final bool tallScreen = screenSize.height > tallScreenBreakpoint;
          final double topPadding =
              tallScreen ? topPaddingLarge : topPaddingSmall;
          final double bottomPadding =
              tallScreen ? bottomPaddingLarge : bottomPaddingSmall;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: topPadding,
              left: horizontalPadding,
              right: horizontalPadding,
              bottom: bottomPadding,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardWidth),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 24,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: cardPadding,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
