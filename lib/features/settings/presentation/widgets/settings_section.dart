import 'package:ai_tutor_web/features/settings/domain/models/settings_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SettingsSectionWidget extends StatelessWidget {
  const SettingsSectionWidget({
    super.key,
    required this.section,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onNavigate,
  });

  final SettingsSection section;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;
  final ValueChanged<SettingsItem> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: AppTypography.sectionTitle.copyWith(fontSize: 18)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.sidebarBorder),
          ),
          child: Column(
            children: [
              for (int i = 0; i < section.items.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.sidebarBorder,
                  ),
                _SettingsTile(
                  item: section.items[i],
                  notificationsEnabled: notificationsEnabled,
                  onToggleNotifications: onToggleNotifications,
                  onNavigate: onNavigate,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.item,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onNavigate,
  });

  final SettingsItem item;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;
  final ValueChanged<SettingsItem> onNavigate;

  @override
  Widget build(BuildContext context) {
    final bool isToggle = item.kind == SettingsItemKind.toggle;

    return InkWell(
      onTap: isToggle ? null : _handleTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Icon(item.icon,
                color: item.destructive ? AppColors.accentOrange : AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.label,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 15,
                  fontWeight: item.destructive ? FontWeight.w700 : FontWeight.w600,
                  color: item.destructive ? AppColors.accentOrange : AppColors.textPrimary,
                ),
              ),
            ),
            if (isToggle)
              Switch.adaptive(
                value: notificationsEnabled,
                onChanged: onToggleNotifications,
              )
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.iconMuted),
          ],
        ),
      ),
    );
  }

  void _handleTap() {
    onNavigate(item);
  }
}
