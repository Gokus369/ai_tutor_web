import 'package:ai_tutor_web/features/dashboard/domain/models/quick_action.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/utils/dashboard_layout.dart';
import 'package:ai_tutor_web/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    super.key,
    required this.actions,
    required this.availableWidth,
    required this.isDesktop,
  });

  final List<QuickAction> actions;
  final double availableWidth;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final layout = buildQuickActionsLayout(
      availableWidth: availableWidth,
      actionCount: actions.length,
      isDesktop: isDesktop,
    );

    final child = layout.isFixedWidth
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions
                .map(
                  (action) => SizedBox(
                    width: layout.itemWidth,
                    child: QuickActionButton(
                      label: action.label,
                      icon: action.icon,
                      color: action.color,
                      onTap: action.onTap,
                    ),
                  ),
                )
                .toList(),
          )
        : Wrap(
            spacing: layout.spacing!,
            runSpacing: layout.spacing!,
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.start,
            children: actions
                .map(
                  (action) => SizedBox(
                    width: layout.wrapWidth,
                    child: QuickActionButton(
                      label: action.label,
                      icon: action.icon,
                      color: action.color,
                      onTap: action.onTap,
                    ),
                  ),
                )
                .toList(),
          );

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: AppColors.quickActionsContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.summaryCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.sectionTitle.copyWith(
              color: AppColors.quickActionsTitle,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}
