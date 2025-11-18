import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.radius = 20,
    this.textStyle,
    this.height,
    this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double radius;
  final TextStyle? textStyle;
  final double? height;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: (textStyle ?? AppTypography.statusChip(textColor)).copyWith(color: textColor),
        ),
      ],
    );

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
