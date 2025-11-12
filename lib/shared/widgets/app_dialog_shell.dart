import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

/// Shared dialog container that standardizes padding, shape and title styling.
class AppDialogShell extends StatelessWidget {
  const AppDialogShell({
    super.key,
    required this.title,
    required this.child,
    this.width = 620,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
    this.insetPadding = const EdgeInsets.all(24),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final String title;
  final Widget child;
  final double width;
  final EdgeInsetsGeometry padding;
  final EdgeInsets insetPadding;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: insetPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              Center(
                child: Text(
                  title,
                  style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class AppDialogActions extends StatelessWidget {
  const AppDialogActions({
    super.key,
    required this.primaryLabel,
    required this.onPrimaryPressed,
    this.onCancel,
    this.cancelLabel = 'Cancel',
    this.buttonSize = const Size(163, 48),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.primaryStyle,
    this.cancelStyle,
  });

  final String primaryLabel;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onCancel;
  final String cancelLabel;
  final Size buttonSize;
  final MainAxisAlignment mainAxisAlignment;
  final ButtonStyle? primaryStyle;
  final ButtonStyle? cancelStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        SizedBox(
          width: buttonSize.width,
          height: buttonSize.height,
          child: OutlinedButton(
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
            style:
                cancelStyle ??
                OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  foregroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            child: Text(cancelLabel),
          ),
        ),
        SizedBox(
          width: buttonSize.width,
          height: buttonSize.height,
          child: ElevatedButton(
            onPressed: onPrimaryPressed,
            style:
                primaryStyle ??
                ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            child: Text(primaryLabel),
          ),
        ),
      ],
    );
  }
}
