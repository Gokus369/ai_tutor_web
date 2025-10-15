import 'package:ai_tutor_web/features/ai_tutor/presentation/widgets/ai_tutor_styles.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AiTutorSectionCard extends StatelessWidget {
  const AiTutorSectionCard({
    super.key,
    required this.title,
    required this.children,
    this.withDividers = false,
  });

  final String title;
  final List<Widget> children;
  final bool withDividers;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
      decoration: AiTutorStyles.sectionCard(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.sectionTitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ..._buildChildren(children),
        ],
      ),
    );
  }

  List<Widget> _buildChildren(List<Widget> items) {
    final List<Widget> widgets = [];
    final Color dividerColor = AppColors.sidebarBorder.withValues(alpha: 0.7);
    for (int i = 0; i < items.length; i++) {
      widgets.add(items[i]);
      if (i < items.length - 1) {
        if (withDividers) {
          widgets.add(const SizedBox(height: 18));
          widgets.add(Divider(
            height: 20,
            thickness: 1,
            color: dividerColor,
          ));
          widgets.add(const SizedBox(height: 18));
        } else {
          widgets.add(const SizedBox(height: 20));
        }
      }
    }
    return widgets;
  }
}
