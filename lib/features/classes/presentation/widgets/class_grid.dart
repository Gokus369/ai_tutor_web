import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/features/classes/presentation/widgets/class_card.dart';
import 'package:flutter/material.dart';

class ClassGrid extends StatelessWidget {
  const ClassGrid({
    super.key,
    required this.classes,
    required this.contentWidth,
  });

  final List<ClassInfo> classes;
  final double contentWidth;

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

    final double cardWidth =
        columns == 1 ? contentWidth : (contentWidth - spacing * (columns - 1)) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: 24,
      children: classes
          .map(
            (info) => SizedBox(
              width: cardWidth,
              child: ClassCard(info: info),
            ),
          )
          .toList(),
    );
  }
}

