import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    required this.children,
    this.breakpoint = 720,
    this.spacing = 16,
    this.runSpacing = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    this.backgroundColor = AppColors.studentsFilterBackground,
    this.borderColor = AppColors.studentsFilterBorder,
    this.borderRadius = 16,
    this.alignment = WrapAlignment.start,
    this.forceColumn,
  });

  final List<Widget> children;
  final double breakpoint;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final WrapAlignment alignment;
  final bool? forceColumn;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool stack = forceColumn ?? constraints.maxWidth < breakpoint;
        final Widget child = stack
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildColumnChildren(),
              )
            : Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                alignment: alignment,
                children: children,
              );

        return Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: child,
        );
      },
    );
  }

  List<Widget> _buildColumnChildren() {
    final List<Widget> columnChildren = [];
    for (int i = 0; i < children.length; i++) {
      columnChildren.add(children[i]);
      if (i != children.length - 1) {
        columnChildren.add(SizedBox(height: runSpacing));
      }
    }
    return columnChildren;
  }
}
