import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClassGrid extends StatelessWidget {
  const ClassGrid({
    super.key,
    required this.classes,
    required this.contentWidth,
    this.onPatch,
    this.onDelete,
  });

  final List<ClassInfo> classes;
  final double contentWidth;
  final ValueChanged<ClassInfo>? onPatch;
  final ValueChanged<ClassInfo>? onDelete;

  @override
  Widget build(BuildContext context) {
    const double spacing = 24;

    final int columns;
    if (contentWidth >= 1080) {
      columns = 3;
    } else if (contentWidth >= 720) {
      columns = 2;
    } else {
      columns = 1;
    }

    final double cardWidth = columns == 1
        ? contentWidth
        : (contentWidth - spacing * (columns - 1)) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: 24,
      children: classes
          .map(
            (info) => SizedBox(
              width: cardWidth,
              child: ClassCard(
                info: info,
                onViewDetails: () =>
                    context.push(AppRoutes.classDetails, extra: info),
                onPatch: onPatch == null ? null : () => onPatch!(info),
                onDelete: onDelete == null ? null : () => onDelete!(info),
              ),
            ),
          )
          .toList(),
    );
  }
}
