import 'package:ai_tutor_web/features/settings/domain/models/settings_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsDemoData {
  SettingsDemoData._();

  static SettingsData build() {
    return SettingsData(
      profile: const SettingsProfile(
        name: 'Moni Roy',
        role: 'Administrator',
        email: 'moni.roy@aitutor.com',
        avatarColor: AppColors.primary,
      ),
      sections: [
        SettingsSection(
          title: 'Account Settings',
          items: [
            const SettingsItem(icon: Icons.lock_outline, label: 'Change Password'),
            const SettingsItem(
              icon: Icons.notifications_active_outlined,
              label: 'Manage Notifications',
              kind: SettingsItemKind.toggle,
            ),
          ],
        ),
        const SettingsSection(
          title: 'Preferences',
          items: [
            SettingsItem(icon: Icons.menu_book_outlined, label: 'Academic Preferences'),
          ],
        ),
        const SettingsSection(
          title: 'Info',
          items: [
            SettingsItem(icon: Icons.info_outline, label: 'About Us'),
            SettingsItem(icon: Icons.description_outlined, label: 'Terms & Conditions'),
          ],
        ),
        const SettingsSection(
          title: 'Actions',
          items: [
            SettingsItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              destructive: true,
              kind: SettingsItemKind.action,
            ),
          ],
        ),
      ],
    );
  }
}
